module Emergency

  class Runner
    include Utils::Timer

    attr_accessor :path, :record

    def self.run!(path, record)
      runner = new(path, record)
      runner.run!
    end

    def initialize(path, record = false)
      @path = path
      @record = record
    end

    def run!
      emergency = Emergency::Base.new(path, record)

      time_diff = time "Saving people in #{path} ..." do
        emergency.go!
      end

    end

  end
end