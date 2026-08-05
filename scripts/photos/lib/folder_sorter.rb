# frozen_string_literal: true

require "tty-logger"
require "tty-spinner"

# Sorts a card dump directory into dated YYYYMMDD-shooting folders,
# then organises each into jpg/ and DNG/ subfolders.
# Sidecars (xmp, pp3, rrdata) follow their primary file.
# Safe to re-run: mv never overwrites, empty subdirs are removed.

class FolderSorter
  SIDECAR_EXTS = %w[xmp pp3 rrdata].freeze
  PRIMARY_DIRS = { %w[jpg jpeg] => "jpg", %w[dng] => "DNG" }.freeze

  def initialize(dir, logger:)
    @dir    = File.expand_path(dir.to_s.chomp("/"))
    @logger = logger
  end

  def run
    abort "Directory not found: #{@dir}" unless Dir.exist?(@dir)
    sort_by_exif
    shooting_dirs.each { |d| process(d) }
    @logger.success("Done — #{@dir}")
    system("open", @dir)
  end

  private

  # ---------------------------------------------------------------------------
  # 1. exiftool: move primary files into YYYYMMDD-shooting/ by DateTimeOriginal
  # ---------------------------------------------------------------------------
  def sort_by_exif
    spinner = TTY::Spinner.new("[:spinner] Sorting files by DateTimeOriginal…", format: :dots)
    spinner.auto_spin

    exclude_flags = SIDECAR_EXTS.map { |e| "--ext #{e}" }.join(" ")
    cmd = "exiftool -d '%Y%m%d-shooting' '-Directory<DateTimeOriginal' #{exclude_flags} \"#{@dir}\""
    ok  = system(cmd, out: File::NULL, err: File::NULL)

    spinner.stop(ok ? "done." : "exiftool returned non-zero (some files may lack EXIF).")
  end

  # ---------------------------------------------------------------------------
  # 2. For each shooting folder, move primaries + sidecars into subfolders
  # ---------------------------------------------------------------------------
  def process(shooting_dir)
    label = File.basename(shooting_dir)
    @logger.info("Processing #{label}")

    PRIMARY_DIRS.each do |exts, subfolder|
      dest = File.join(shooting_dir, subfolder)
      FileUtils.mkdir_p(dest)

      loose_primaries(shooting_dir, exts).each do |img|
        move_with_sidecars(img, dest, shooting_dir)
      end
    end

    rescue_stranded_sidecars(shooting_dir)
    remove_empty_subdirs(shooting_dir)
  end

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------
  def shooting_dirs
    Dir.glob(File.join(@dir, "*-shooting")).select { |d| File.directory?(d) }.sort
  end

  def loose_primaries(shooting_dir, exts)
    exts.flat_map do |ext|
      Dir.glob(File.join(shooting_dir, "*.#{ext}")) +
        Dir.glob(File.join(shooting_dir, "*.#{ext.upcase}"))
    end.uniq
  end

  def move_with_sidecars(img, dest, shooting_dir)
    base      = File.basename(img)
    dest_file = File.join(dest, base)
    FileUtils.mv(img, dest_file) unless File.exist?(dest_file)

    SIDECAR_EXTS.each do |ext|
      sidecar      = File.join(shooting_dir, "#{base}.#{ext}")
      dest_sidecar = File.join(dest, File.basename(sidecar))
      next unless File.exist?(sidecar)
      next if File.exist?(dest_sidecar)

      FileUtils.mv(sidecar, dest_sidecar)
      @logger.debug("sidecar #{File.basename(sidecar)}")
    end
  end

  # Walk backwards through extensions to find an embedded image type.
  # Handles multi-segment names like R0000968.JPG.c79092.rrdata.
  def rescue_stranded_sidecars(shooting_dir)
    Dir.glob(File.join(shooting_dir, "*.{#{SIDECAR_EXTS.join(",")}}")).each do |sidecar|
      dest = dest_for_sidecar(shooting_dir, File.basename(sidecar))
      next unless dest && Dir.exist?(dest)

      dest_path = File.join(dest, File.basename(sidecar))
      next if File.exist?(dest_path)

      @logger.warn("rescuing #{File.basename(sidecar)} → #{File.basename(dest)}/")
      FileUtils.mv(sidecar, dest_path)
    end
  end

  def dest_for_sidecar(shooting_dir, sidecar_base)
    name = sidecar_base.dup
    while name.include?(".")
      name = File.basename(name, File.extname(name))
      ext  = File.extname(name).delete_prefix(".").downcase
      PRIMARY_DIRS.each do |exts, subfolder|
        return File.join(shooting_dir, subfolder) if exts.include?(ext)
      end
    end
    nil
  end

  def remove_empty_subdirs(shooting_dir)
    PRIMARY_DIRS.values.each do |subfolder|
      path = File.join(shooting_dir, subfolder)
      next unless Dir.exist?(path) && Dir.empty?(path)

      Dir.rmdir(path)
      @logger.debug("removed empty #{subfolder}/")
    end
  end
end
