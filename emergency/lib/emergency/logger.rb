module Emergency

  class Logger
    @@loggers = {}

    def self.logger
      @@logger
    end
    
    def self.log
      @@logger.log
    end

    def self.retrieve(id)
      @loggers[id]
    end

    def self.log!(id, debug = false)
      logger = new(id, debug)
      @@logger = logger
      @@loggers[id] = logger
    end

    def self.record(text)
      @@logger.record text
    end
    
    def self.save!
      unless @debug
        filename = "out/results_#{Time.now.to_i}"
        file = File.new(filename, "w")
      
        log.each do |line|
          file.puts line
        end
      
        puts ">> Saved to #{filename}"
      end
    end
    
    attr_reader :log
    def initialize(id, debug = false)
      @id = id
      @debug = debug
      @log = []
    end

    def record(text)
      puts ">> #{text}"
      @log << text unless @debug
    end

  end
end