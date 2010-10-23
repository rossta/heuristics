module Emergency

  class Base
    include Utils::Timer
    attr_accessor :people, :hospitals

    def initialize(path, debug = false)
      @path = path
      @debug = debug
    end

    def go!
      @most_saved = 0
      @best_run   = 0

      50.times do |iter|
        [Person, Hospital, Ambulance].each { |klass| klass.acts_as_named }
        time "Locating people..." do
          initialize_space!
          puts " num of people            : #{Person.all.size}"
          puts " num of hospitals         : #{Hospital.all.size}"
        end

        time "Locating hospitals..." do
          locate_hospitals!
        end

        time "Sending out ambulances... " do
          respond_to_emergency!(iter)
        end
      end

      time "Saving to file..." do
        save_to_results_file!
        puts " best iteration           : #{@best_run}"
        puts " num of people saved      : #{@most_saved}"
      end
    end

    def initialize_space!
      @people, @hospitals = Parser.new(@path).parse
      Hospital.all = @hospitals
      Person.all = @people
    end

    def locate_hospitals!
      grid = Grid.create(@people.map(&:x), @people.map(&:y))
      @hospitals.each do |h|
        h.position.x = rand(grid.width)
        h.position.y = rand(grid.height)
        h.assign_ambulance_positions
      end
    end

    def respond_to_emergency!(iter)
      puts "Attempt #{iter}"
      Logger.log!(iter, @debug)
      hospital_list = @hospitals.map {|h| "#{h.name} (#{h.to_coord.join(',')})" }.join(" ")
      Logger.record "Hospitals #{hospital_list}"
      @hospitals.each do |h|
        h.ambulances.each do |a|
          a.travel(@people)
        end
      end
      saved = Person.saved.size
      puts " num of people saved      : #{saved}"
      if saved > @most_saved
        @most_saved = saved
        @best_run   = iter
      end
    end

    def save_to_results_file!
      Logger.save!(@best_run)
    end

  end

  class Grid
    def self.create(x_list, y_list)
      min_x = x_list.min
      min_y = y_list.min
      max_x = x_list.max
      max_y = y_list.max
      Grid.new(Position.new(min_x, min_y), Position.new(max_x, max_y))
    end

    attr_accessor :sw, :ne
    def initialize(sw, ne)
      @sw = sw
      @ne = ne
    end

    def center
      @center ||= Position.center(@sw, @ne)
    end

    def width
      @width ||= ne.x - sw.x
    end

    def height
      @height ||= ne.y - sw.y
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