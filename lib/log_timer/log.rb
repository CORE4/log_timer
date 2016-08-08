module LogTimer
  # Represents a log file
  class Log
    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def modification_date
      File.mtime(@path)
    end

    # Checks if the log file is older than the given datetime
    def older?(reference_time)
      File.mtime(@path) < reference_time
    end

    # Returns the last n lines from the log file
    # Implementing this directly in Ruby is annoyingly complicated (and/or slow) it seems
    def tail(lines = 10)
      `tail -n #{lines} #{@path}`.split("\n")
    end
  end
end
