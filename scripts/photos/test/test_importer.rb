require "minitest/autorun"
require "stringio"
require_relative "../lib/importer"

class TestImporter < Minitest::Test
  def setup
    ENV["RAW_ARCHIVE_PATH"] = "/tmp/fake_archive"
    @logger = TTY::Logger.new { |c| c.output = File.open(File::NULL, "w") }
  end

  def test_aborts_if_exiftool_missing
    importer = Importer.new("/tmp/fake_source", logger: @logger)
    
    # Mock system to simulate missing exiftool
    def importer.system(cmd, *args, **kwargs)
      return false if cmd.to_s.include?("which exiftool")
      super
    end

    stderr_capture = StringIO.new
    original_stderr = $stderr
    $stderr = stderr_capture

    begin
      error = assert_raises(SystemExit) do
        importer.run
      end
      
      assert_equal 1, error.status
      assert_includes stderr_capture.string, "Error: 'exiftool' is not installed. Please install it first."
    ensure
      $stderr = original_stderr
    end
  end
end
