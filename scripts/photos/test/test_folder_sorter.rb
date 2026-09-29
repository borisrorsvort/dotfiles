require "minitest/autorun"
require "stringio"
require_relative "../lib/folder_sorter"
require "tty-logger"

class TestFolderSorter < Minitest::Test
  def setup
    @logger = TTY::Logger.new { |c| c.output = File.open(File::NULL, "w") }
  end

  def test_aborts_if_exiftool_missing
    sorter = FolderSorter.new("/tmp/fake_dir", logger: @logger)
    
    # Mock system
    def sorter.system(cmd, *args, **kwargs)
      return false if cmd.to_s.include?("which exiftool")
      super
    end

    stderr_capture = StringIO.new
    original_stderr = $stderr
    $stderr = stderr_capture

    begin
      error = assert_raises(SystemExit) do
        sorter.run
      end
      
      assert_equal 1, error.status
      assert_includes stderr_capture.string, "Error: 'exiftool' is not installed. Please install it first."
    ensure
      $stderr = original_stderr
    end
  end
end
