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

    def self.log!(id)
      logger = new(id)
      @@logger = logger
      @@loggers[id] = logger
    end

    def self.record(text)
      @@logger.record text
    end
    
    attr_reader :log
    def initialize(id)
      @id = id
      @log = []
    end

    def record(text)
      puts ">> #{text}"
      @log << text
    end

  end
end