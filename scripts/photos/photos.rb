#!/usr/bin/env ruby
# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] = File.join(__dir__, "Gemfile")

require "bundler/setup"
require "tty-prompt"
require "tty-box"
require "tty-logger"
require "dotenv"
require "fileutils"

Dotenv.load(File.join(__dir__, ".env"), ".env")

require_relative "lib/folder_sorter"
require_relative "lib/importer"
require_relative "lib/publisher"

class PhotosCLI
  COMMANDS = {
    "import"  => "Import photos from camera mount into /mnt/darkmatter/CameraRoll Raws",
    "sort"    => "Sort a card dump into YYYYMMDD-shooting/{jpg,DNG}",
    "publish" => "Export, watermark, tag EXIF and push to Immich"
  }.freeze

  def initialize(argv)
    @argv   = argv.dup
    @prompt = TTY::Prompt.new(interrupt: :exit)
    @logger = TTY::Logger.new { |c| c.level = :debug }
  end

  def run
    banner
    cmd  = @argv.shift
    args = @argv

    case cmd
    when "import"               then import_cmd(args)
    when "sort"                 then sort(args)
    when "publish"              then publish
    when "help", "--help", "-h" then usage
    when nil                    then interactive
    else
      @logger.error("Unknown command: #{cmd}")
      puts
      usage
      exit 1
    end
  end

  private

  def import_cmd(args)
    dir = args.first || pick_mount_dir
    Importer.new(dir, logger: @logger).run
  end

  def sort(args)
    dir = args.first || Dir.pwd
    FolderSorter.new(dir, logger: @logger).run
  end

  def publish
    Publisher.new(prompt: @prompt, logger: @logger).run
  end

  def interactive
    choices = COMMANDS.each_with_object({}) { |(cmd, desc), h| h["#{cmd.ljust(8)} - #{desc}"] = cmd }
    choice = @prompt.select("What do you want to do?", choices, cycle: true)
    case choice
    when "import"
      dir = pick_mount_dir
      import_cmd([dir])
    when "sort"
      dir = pick_sort_dir
      sort([dir])
    when "publish"
      publish
    end
  end

  def pick_mount_dir
    candidates = []
    if ENV["CAMERA_MOUNT_PATH"]
      path = ENV["CAMERA_MOUNT_PATH"].strip
      candidates << path if path.start_with?("mtp://", "gphoto2://") || Dir.exist?(path)
    end
    candidates += Dir.glob("/run/media/*/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates += Dir.glob("/media/*/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates += Dir.glob("/Volumes/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates.uniq!

    if candidates.empty?
      @logger.warn("No automatically detected mounts found.")
      return @prompt.ask("Enter path to camera mount manually:", default: Dir.pwd)
    end

    choices = candidates.each_with_object({}) { |path, h| h[path] = path }
    choices["Enter a custom path…"] = :custom

    picked = @prompt.select("Camera mount to import from:", choices)
    picked == :custom ? @prompt.ask("Path:", default: Dir.pwd) : picked
  end

  def pick_sort_dir
    candidates = [Dir.pwd]
    candidates << ENV["RAW_ARCHIVE_PATH"] if ENV["RAW_ARCHIVE_PATH"] && Dir.exist?(ENV["RAW_ARCHIVE_PATH"])
    candidates += Dir.glob("/run/media/*/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates += Dir.glob("/media/*/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates += Dir.glob("/Volumes/*/").select { |d| File.directory?(d) }.map { |d| d.chomp("/") }
    candidates.uniq!

    choices = candidates.each_with_object({}) do |path, h|
      h[path == Dir.pwd ? "#{path}  (current dir)" : path] = path
    end
    choices["Enter a custom path…"] = :custom

    picked = @prompt.select("Directory to sort:", choices)
    picked == :custom ? @prompt.ask("Path:", default: Dir.pwd) : picked
  end

  def banner
    puts TTY::Box.frame(
      "Photos workflow CLI",
      padding: [0, 2],
      border:  :thick,
      align:   :center,
      style:   { fg: :cyan, border: { fg: :cyan } }
    )
  end

  def usage
    puts "Usage: photos <command> [options]\n\n"
    COMMANDS.each { |name, desc| puts format("  %-10s %s", name, desc) }
    puts
  end
end

PhotosCLI.new(ARGV).run
