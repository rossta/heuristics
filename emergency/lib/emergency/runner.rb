module Emergency

  class Runner
    include Utils::Timer

    attr_accessor :path

    def self.run!(path)
      runner = new(path)
      runner.run!
    end

    def initialize(path)
      @path = path
    end

    def run!
      emergency = Emergency::Base.new(path)

      time_diff = time "Saving people in #{path} ..." do
        emergency.go!
      end
    end

  end
end