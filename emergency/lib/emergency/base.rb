module Emergency

  class Base
    include Utils::Timer
    attr_accessor :people, :hospitals

    def initialize(path, opts = {})
      @path = path
      @opts = opts
    end

    def go!
      @most_saved = 0
      @best_run   = 0
      @best_grid  = nil

      begin
        with_timeout 118 do
          time "Locating people..." do
            initialize_space!
            puts " num of people            : #{Person.all.size}"
            puts " num of hospitals         : #{Hospital.all.size}"
          end

          1000.times do |iter|
            begin
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
        time "Finishing..." do
          save_to_results_file!           if @opts[:record]
          puts " best iteration           : #{@best_run}"
          puts " num of people saved      : #{@most_saved}"
        end
      end
    end

    def initialize_space!
      [Person, Hospital, Ambulance].each { |klass| klass.acts_as_named }
      @people, @hospitals = Parser.new(@path).parse
      @ambulances   = @hospitals.map(&:ambulances).flatten.sort { |a_1, a_2| a_1.name.to_i <=> a_2.name.to_i }
      Hospital.all  = @hospitals
      Person.all    = @people
      Ambulance.all = @ambulances
      @locations    = @people.map(&:description)
    end

    def respond_to_emergency!(iter)
      puts "Attempt #{iter}"
      Logger.log!(iter, @opts)

      grid = Grid.create(@locations)

      centroids = grid.centroids(@hospitals.size)

      @hospitals.sort { |h_1, h_2| h_2.ambulances.size <=> h_1.ambulances.size }.each_with_index do |h, i|
        h.position = centroids[i]
        h.reset_ambulances
      end
      Person.reset_all

      hospital_list = @hospitals.map {|h| "#{h.name} (#{h.to_coord.join(',')})" }.join(" ")
      Logger.record "Hospitals #{hospital_list}"

      while a = Ambulance.next do
        a.save_all(@people)
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
          cents << [cent_x, cent_y, cluster.size]
        end
        cents.sort! { |c_1,c_2| c_2[2] <=> c_1[2] }
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