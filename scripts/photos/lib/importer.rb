# frozen_string_literal: true

require "tty-logger"
require "tty-spinner"
require "fileutils"
require_relative "folder_sorter"

class Importer
  def initialize(source_dir, logger:)
    # Do not chomp trailing slash or expand path if it is an MTP/Gphoto2 URI
    @source_dir = if source_dir.to_s.start_with?("mtp://", "gphoto2://")
                    source_dir.to_s
                  else
                    File.expand_path(source_dir.to_s.chomp("/"))
                  end
    @dest_dir = ENV.fetch("RAW_ARCHIVE_PATH") { abort("Please set RAW_ARCHIVE_PATH in .env") }
    @logger = logger
  end

  def run
    abort("Error: 'exiftool' is not installed. Please install it first.") unless system("which exiftool > /dev/null 2>&1")
    FileUtils.mkdir_p(@dest_dir)

    if @source_dir.start_with?("mtp://", "gphoto2://")
      import_from_mtp
    else
      abort "Source directory not found: #{@source_dir}" unless Dir.exist?(@source_dir)
      import_by_exif(@source_dir)
    end

    @logger.info("Cleaning up and sorting sidecars in #{@dest_dir}...")
    FolderSorter.new(@dest_dir, logger: @logger).run
  end

  private

  def import_from_mtp
    system("gio", "mount", @source_dir, out: File::NULL, err: File::NULL)
    spinner = TTY::Spinner.new("[:spinner] Indexing MTP device and local archive…", format: :dots)
    spinner.auto_spin

    existing = {}
    Dir.glob(File.join(@dest_dir, "**", "*")).each do |f|
      next if File.directory?(f)

      existing[[File.basename(f), File.size(f)]] = true
    end

    pending_uris = []

    scan_mtp = lambda do |uri|
      require "open3"
      output, _err, _status = Open3.capture3("gio", "list", "-l", uri)
      output.lines.each do |line|
        parts = line.chomp.split("\t")
        name = parts[0]
        size = parts[1].to_i
        type = parts.last

        child_uri = uri.chomp("/") + "/" + name

        if type.to_s.include?("directory")
          scan_mtp.call(child_uri)
        else
          next unless name.to_s.match?(/\.(jpg|jpeg|dng|mp4|mov|avi)$/i)

          pending_uris << child_uri unless existing[[name, size]]
        end
      end
    end

    scan_mtp.call(@source_dir)
    spinner.stop(pending_uris.empty? ? "No new files found." : "Found #{pending_uris.size} new files.")
    return if pending_uris.empty?

    staging_dir = File.join(@dest_dir, "tmp_mtp_staging")
    FileUtils.mkdir_p(staging_dir)

    download_spinner = TTY::Spinner.new("[:spinner] Downloading #{pending_uris.size} files over MTP…", format: :dots)
    download_spinner.auto_spin

    pending_uris.each do |uri|
      dest = File.join(staging_dir, File.basename(uri))
      system("gio", "copy", uri, dest, out: File::NULL, err: File::NULL)
    end
    download_spinner.success("done.")

    import_by_exif(staging_dir)
    FileUtils.rm_rf(staging_dir)
  end

  def import_by_exif(source_path)
    spinner = TTY::Spinner.new("[:spinner] Importing files from #{source_path}…", format: :dots)
    spinner.auto_spin

    # 1. Import JPGs directly to the jpg/ subfolder
    cmd_jpg = "exiftool -r -ext jpg -ext jpeg -d '#{@dest_dir}/%Y%m%d-shooting/jpg' '-Directory<DateTimeOriginal' -o . \"#{source_path}\""
    system(cmd_jpg, out: File::NULL, err: File::NULL)

    # 2. Import DNGs directly to the DNG/ subfolder
    cmd_dng = "exiftool -r -ext dng -d '#{@dest_dir}/%Y%m%d-shooting/DNG' '-Directory<DateTimeOriginal' -o . \"#{source_path}\""
    system(cmd_dng, out: File::NULL, err: File::NULL)

    # 3. Import everything else (like videos) into the root of the shooting folder
    cmd_other = "exiftool -r --ext jpg --ext jpeg --ext dng -d '#{@dest_dir}/%Y%m%d-shooting' '-Directory<DateTimeOriginal' -o . \"#{source_path}\""
    system(cmd_other, out: File::NULL, err: File::NULL)

    # Exiftool naturally skips files that already exist in the destination (no %c used).
    # This fulfills the "check for duplicate shooting date, add the missing one" requirement perfectly,
    # taking zero extra disk writes for duplicates.

    spinner.success("done.")
  end
end
