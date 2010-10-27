module Emergency

  class Logger
    @@loggers = {}

    def self.logger
      @@logger
    end

    def self.retrieve(id)
      @@loggers[id]
    end

    def self.log!(id, opts = {})
      @@logger = new(id, opts)
      @@loggers[id] = @@logger
    end

    def self.record(text)
      @@logger.record text
    end

    def self.save!(id)
      logger = retrieve(id)
      unless @record
        filename = "out/results_#{Time.now.to_i}"
        file = File.new(filename, "w")

        logger.log.each do |line|
          file.puts line
        end

        puts ">> Saved to #{filename}"
      end
    end

    attr_reader :log
    def initialize(id, opts = {})
      @id = id
      @log = []
      @record = opts[:record] || false
      @verbose = opts[:verbose] || false
    end

    def record(text)
      puts ">> #{text}" if @verbose
      @log << text if @record
    end

  end
end