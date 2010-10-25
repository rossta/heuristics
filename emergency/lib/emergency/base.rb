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
      @best_grid  = nil

      begin
        with_timeout 118 do
          1000.times do |iter|
            begin
              [Person, Hospital, Ambulance].each { |klass| klass.acts_as_named }

              time "Locating people..." do
                initialize_space!
                puts " num of people            : #{Person.all.size}"
                puts " num of hospitals         : #{Hospital.all.size}"
              end

              time "Sending out ambulances... " do
                respond_to_emergency!(iter)
              end
            rescue TypeError
              next
            end
          end
        end
      rescue Timeout::Error
        puts "Time's up!...\n"
        time "Saving to file..." do
          save_to_results_file!
          puts " best iteration           : #{@best_run}"
          puts " num of people saved      : #{@most_saved}"
        end
      end
    end

    def initialize_space!
      @people, @hospitals = Parser.new(@path).parse
      Hospital.all  = @hospitals
      Person.all    = @people
    end

    def respond_to_emergency!(iter)
      puts "Attempt #{iter}"
      Logger.log!(iter, @debug)

      grid = Grid.create(@people.map(&:description))

      centroids = grid.centroids(@hospitals.size)

      @hospitals.each_with_index do |h, i|
        h.position = centroids[i]
        h.assign_ambulance_positions
      end

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
        @best_grid  = grid
      end
    end

    def save_to_results_file!
      Logger.save!(@best_run)
    end

  end

  class Grid
    def self.create(points)
      Grid.new(points)
    end

    attr_accessor :sw, :ne
    def initialize(points)
      @points = points
      x_list = points.map { |p| p[0] }
      y_list = points.map { |p| p[1] }
      min_x = x_list.min
      min_y = y_list.min
      max_x = x_list.max
      max_y = y_list.max
      @sw = Position.new(min_x, min_y)
      @ne = Position.new(max_x, max_y)
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

    def centroids(num)
      centroids = []
      num.to_i.times { centroids << [rand(width), rand(height)] }

      while true
        clusters = {}
        centroids.each { |c| clusters[c] = [c] }
        @points.each do |pt|
          min_cent = centroids.first
          min_dist = Position.distance(pt, min_cent)
          other_centroids = centroids - [min_cent]
          other_centroids.each do |cent|
            dist = Position.distance(pt, cent)
            if dist < min_dist
              min_dist = dist
              min_cent = cent
            end
          end
          clusters[min_cent] << pt
        end

        cents = []

        clusters.each do |cent, cluster|
          unless cluster.empty?
            cent_x = (cluster.map { |p| p[0] }.inject(&:+) / cluster.size).to_i
            cent_y = (cluster.map { |p| p[1] }.inject(&:+) / cluster.size).to_i
          else
            cent_x = cent[0]
            cent_y = cent[1]
          end
          cents << [cent_x, cent_y]
        end
        break if cents.sort == centroids.sort
        centroids = cents
      end

      centroids.map { |c| Position.new(c[0], c[1]) }
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