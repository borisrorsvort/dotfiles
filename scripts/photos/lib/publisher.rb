# frozen_string_literal: true

require "fileutils"
require "time"
require "json"
require "tty-spinner"

# Interactive pipeline: RapidRAW export → watermark → EXIF tag → rename → Immich
class Publisher
  AUTHOR    = "Boris Rorsvort"
  COPYRIGHT = "© Boris Rorsvort"

  def initialize(prompt:, logger:)
    @prompt = prompt
    @logger = logger

    @shooting_path  = ENV.fetch("SHOOTING_PATH", "/Volumes/Shootings")
    raw_wm_path     = ENV.fetch("WATERMARK_PATH") { abort("Set WATERMARK_PATH in .env first.") }
    @watermark_path = File.expand_path(raw_wm_path, File.expand_path("..", __dir__))
    @immich_server  = ENV["IMMICH_SERVER"]
    @immich_api_key = ENV["IMMICH_API_KEY"]

    abort("Watermark not found at #{@watermark_path}") unless File.exist?(@watermark_path)

    @rapidraw_cmd = resolve_rapidraw
    check_tools!
  end

  def run
    folders    = pick_folders
    @title     = ask_title
    @push      = ask_immich?
    @date      = ask_date(folders.first)

    insta_dirs = folders.map { |f| process_folder(f) }.compact.flatten

    open_insta_dirs(insta_dirs)

    immich_msg = @push ? "Album '#{@title}' updated in Immich, " : "Skipped Immich upload, "
    @logger.success("#{immich_msg}#{insta_dirs.size} insta folder(s) opened.")
  end

  private

  # ---------------------------------------------------------------------------
  # Interactive prompts
  # ---------------------------------------------------------------------------
  def pick_folders
    candidates =
      Dir.children(@shooting_path)
         .map    { |n| File.join(@shooting_path, n) }
         .select { |p| File.directory?(p) && !File.basename(p).start_with?(".") }
         .sort_by { |p| File.basename(p) }
         .reverse
         .first(10)

    abort("No folders found in #{@shooting_path}") if candidates.empty?

    choices = candidates.each_with_object({}) do |path, hash|
      base  = File.basename(path)
      label = base =~ /\A(\d{4})(\d{2})(\d{2})/ ? "#{base}  (#{$3}-#{$2}-#{$1})" : base
      hash[label] = path
    end

    selected = @prompt.multi_select("Select shoot folder(s):", choices, per_page: 10)
    abort("Nothing selected.") if selected.empty?
    selected
  end

  def ask_title
    @prompt.ask("Title (EXIF title + Immich album name):") { |q| q.required true }
  end

  def ask_immich?
    push = @prompt.select("Push to Immich?") do |m|
      m.choice "Yes", true
      m.choice "No",  false
    end
    if push
      abort("Set IMMICH_SERVER in .env first.")  unless @immich_server
      abort("Set IMMICH_API_KEY in .env first.") unless @immich_api_key
    end
    push
  end

  def ask_date(first_folder)
    default = date_from_folder(first_folder)
    @prompt.ask("Date (DD-MM-YYYY):", default: default) do |q|
      q.validate(/\A\d{2}-\d{2}-\d{4}\z/, "Format must be DD-MM-YYYY")
    end
  end

  # ---------------------------------------------------------------------------
  # Per-folder pipeline
  # ---------------------------------------------------------------------------
  def process_folder(shooting_folder)
    # Default to the jpg/ subfolder if present, otherwise fall back to shooting_folder
    target_folder = File.join(shooting_folder, "jpg")
    target_folder = shooting_folder unless Dir.exist?(target_folder)

    @logger.info("Processing #{File.basename(shooting_folder)} (#{File.basename(target_folder)})")

    wm_basenames  = find_wm_basenames(target_folder)
    export_parent = File.join(shooting_folder, "export")
    stash_dir     = File.join(File.dirname(shooting_folder), ".tmp_export_#{File.basename(shooting_folder)}")

    stash_existing(export_parent, stash_dir)

    orig_dir  = File.join(stash_dir, "orig")
    insta_dir = File.join(stash_dir, "insta")
    FileUtils.mkdir_p([orig_dir, insta_dir])

    with_spinner("Exporting via RapidRAW…") { export_with_rapidraw(target_folder, orig_dir) }

    if wm_basenames.empty?
      @logger.warn("No images tagged WM — skipping insta export.")
    else
      @logger.info("#{wm_basenames.size} image(s) tagged WM — applying watermarks…")
      apply_watermarks(orig_dir, insta_dir, wm_basenames)
    end

    FileUtils.mv(stash_dir, export_parent)
    final_orig  = File.join(export_parent, "orig")
    final_insta = File.join(export_parent, "insta")

    cleanup_rrdata(final_orig)

    with_spinner("Tagging EXIF + renaming orig…") do
      rename_exports(final_orig, @date, "orig")
      tag_exif(final_orig, @title)
    end

    if wm_basenames.any?
      with_spinner("Tagging EXIF + renaming insta…") do
        rename_exports(final_insta, @date, "insta")
        tag_exif(final_insta, @title)
      end
    end

    push_to_immich(final_orig) if @push

    wm_basenames.any? ? final_insta : nil
  end

  # ---------------------------------------------------------------------------
  # Watermark
  # ---------------------------------------------------------------------------
  def apply_watermarks(orig_dir, insta_dir, wm_basenames)
    Dir.glob(File.join(orig_dir, "*.{jpg,jpeg,png,JPG,JPEG,PNG}")).each do |orig_file|
      base = File.basename(orig_file, File.extname(orig_file))
      next unless wm_basenames.any? { |wm| base.start_with?(wm) }

      insta_file = File.join(insta_dir, File.basename(orig_file))
      dims  = `magick identify -format "%w %h" "#{orig_file}"`.strip.split
      w, h  = dims[0].to_i, dims[1].to_i
      wm_w  = (w * 0.15).to_i
      off_x = w / 6
      off_y = h / 6
      e_x   = (w / 2.5).to_i
      e_y   = (h / 2.5).to_i

      cmd = %(magick "#{orig_file}" ) +
            %(\( "#{@watermark_path}" -resize #{wm_w}x -channel A -evaluate multiply 0.15 +channel -write mpr:wm +delete \) ) +
            %(-gravity center ) +
            %( mpr:wm -geometry -#{off_x}-#{off_y} -compose over -composite ) +
            %( mpr:wm -geometry +#{off_x}-#{off_y} -compose over -composite ) +
            %( mpr:wm -geometry -#{off_x}+#{off_y} -compose over -composite ) +
            %( mpr:wm -geometry +#{off_x}+#{off_y} -compose over -composite ) +
            %( mpr:wm -geometry -#{e_x}-#{e_y}     -compose over -composite ) +
            %( mpr:wm -geometry +#{e_x}-#{e_y}     -compose over -composite ) +
            %( mpr:wm -geometry -#{e_x}+#{e_y}     -compose over -composite ) +
            %( mpr:wm -geometry +#{e_x}+#{e_y}     -compose over -composite ) +
            %(-quality 90 "#{insta_file}")

      with_spinner("  Watermarking #{File.basename(orig_file)}…") { run!(cmd) }
    end
  end

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------
  def with_spinner(label, &block)
    spinner = TTY::Spinner.new("[:spinner] #{label}", format: :dots)
    spinner.auto_spin
    block.call
    spinner.stop("done.")
  end

  def export_with_rapidraw(source, dest)
    rapidraw_dir = File.dirname(@rapidraw_cmd)
    if File.directory?(rapidraw_dir) && @rapidraw_cmd.start_with?("/")
      Dir.chdir(rapidraw_dir) { run_rapidraw(source, dest) }
    else
      run_rapidraw(source, dest)
    end
  end

  def run_rapidraw(source, dest)
    run!(%("#{@rapidraw_cmd}" export "#{source}" --output "#{dest}" --format jpeg --quality 100 --keep-metadata true))
  end

  def find_wm_basenames(folder)
    Dir.glob(File.join(folder, "**", "*.rrdata")).filter_map do |path|
      data = JSON.parse(File.read(path))
      next unless (data["tags"] || []).any? { |t| t.to_s.downcase.include?("wm") }

      base = File.basename(path, ".rrdata")
      File.basename(base, File.extname(base))
    rescue JSON::ParserError
      @logger.warn("Could not parse #{path}")
      nil
    end.uniq
  end

  def rename_exports(dir, date, suffix)
    Dir.glob(File.join(dir, "*.{jpg,jpeg,png,JPG,JPEG,PNG}")).each do |file|
      ext  = File.extname(file)
      base = File.basename(file, ext)
      next if base.end_with?("-#{suffix}")

      dest = File.join(dir, "#{base}-#{date}-#{suffix}#{ext}")
      FileUtils.mv(file, dest, force: true) unless file == dest
    end
  end

  def tag_exif(dir, title)
    files = Dir.glob(File.join(dir, "*.jpg"))
    return if files.empty?

    run!(
      %(exiftool -overwrite_original ) +
      %(-Artist="#{AUTHOR}" -Copyright="#{COPYRIGHT}" ) +
      %(-XMP:Creator="#{AUTHOR}" -IPTC:By-line="#{AUTHOR}" -XMP:Rights="#{COPYRIGHT}" ) +
      %(-XMP:Title="#{title}" -IPTC:ObjectName="#{title}" -ImageDescription="#{title}" ) +
      %("#{dir}"/*.jpg),
      quiet: true
    )
  end

  def push_to_immich(dir)
    with_spinner("Uploading to Immich…") do
      run!(%(immich --url="#{@immich_server}" --key="#{@immich_api_key}" upload --album-name="#{@title}" "#{dir}"))
    end
  end

  def cleanup_rrdata(dir)
    Dir.glob(File.join(dir, "*.rrdata")).each { |f| FileUtils.rm_f(f) }
  end

  def stash_existing(export_parent, stash_dir)
    if File.exist?(stash_dir) && !File.exist?(export_parent)
      FileUtils.mv(stash_dir, export_parent)
    elsif File.exist?(stash_dir) && File.exist?(export_parent)
      FileUtils.rm_rf(stash_dir)
    end
    FileUtils.mv(export_parent, stash_dir) if File.exist?(export_parent)
  end

  def open_insta_dirs(dirs)
    if dirs.any?
      system("open", *dirs)
    else
      @logger.warn("No insta exports produced — nothing to open.")
    end
  end

  def date_from_folder(folder)
    base = File.basename(folder)
    return "#{$3}-#{$2}-#{$1}" if base =~ /\A(\d{4})(\d{2})(\d{2})/

    img = Dir.glob(File.join(folder, "*.{jpg,jpeg,JPG,JPEG,DNG,dng}")).first
    if img
      exif = `exiftool -DateTimeOriginal -d "%d-%m-%Y" -s3 "#{img}" 2>/dev/null`.strip
      return exif unless exif.empty?
    end
    Time.now.strftime("%d-%m-%Y")
  rescue StandardError
    Time.now.strftime("%d-%m-%Y")
  end

  def resolve_rapidraw
    candidates = [
      "/Applications/RapidRAW.app/Contents/MacOS/RapidRAW",
      `command -v rapidraw 2>/dev/null`.strip
    ]
    candidates.find { |c| c && !c.empty? && File.exist?(c) }
  end

  def check_tools!
    missing = %w[exiftool immich magick].reject { |cmd| system("command -v #{cmd} > /dev/null 2>&1") }
    missing << "RapidRAW" unless @rapidraw_cmd
    abort("Missing required tools: #{missing.join(", ")}") if missing.any?
  end

  def run!(cmd, quiet: false)
    @logger.debug(cmd) unless quiet
    ok = quiet ? system(cmd, out: File::NULL, err: File::NULL) : system(cmd)
    abort("Command failed: #{cmd}") unless ok
  end
end
