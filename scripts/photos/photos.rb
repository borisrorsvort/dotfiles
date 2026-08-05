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

$LOAD_PATH.unshift(File.join(__dir__, "lib"))
require "folder_sorter"
require "publisher"

class PhotosCLI
  COMMANDS = {
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
    when "sort"
      dir = pick_sort_dir
      sort([dir])
    when "publish"
      publish
    end
  end

  def pick_sort_dir
    candidates = [Dir.pwd]
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
      "photos",
      padding: [0, 2],
      border:  :thick,
      align:   :center,
      style:   { fg: :cyan, border: { fg: :cyan } }
    )
  end

  def usage
    puts "Usage: photos <command> [options]\n\n"
    COMMANDS.each { |name, desc| puts "  %-10s %s" % [name, desc] }
    puts
  end
end

PhotosCLI.new(ARGV).run
