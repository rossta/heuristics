module Emergency

  class Runner
    include Utils::Timer

    attr_accessor :path, :debug

    def self.run!(path, debug)
      runner = new(path, debug)
      runner.run!
    end

    def initialize(path, debug = false)
      @path = path
      @debug = debug
    end

    def run!
      emergency = Emergency::Base.new(path, debug)

      time_diff = time "Saving people in #{path} ..." do
        emergency.go!
      end

    end

  end
end