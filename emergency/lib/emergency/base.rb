module Emergency

  class Base
    include Utils::Timer
    attr_accessor :people, :hospitals

    def initialize(path)
      @path = path
    end

    def go!
      time "Loading file and initializing cities ..." do
        initialize_space!
        puts " num of people            : #{@cities.size}"
      end
    end

    def initialize_space!
      @people, @hospitals = Parser.new(@path).parse
      require "ruby-debug"; debugger
      1
    end
  end

  class Parser

    def initialize(path)
      @path       = path
      @people     = []
      @hospitals  = []
    end

    def parse
      File.open(@path, "r").readlines.each do |line|
        input = nil
        case line.chomp
        when /^[^\w]+$/, /person/, /hospital/
          next
        when /^\d+\,\d+,\d+$/
          @people << Person.new(*line.chomp.split(",").map(&:to_i))
        when /^\d+$/
          @hospitals << Hospital.new(line.chomp.to_i)
        end
      end

      [@people, @hospitals]
    end
  end
end