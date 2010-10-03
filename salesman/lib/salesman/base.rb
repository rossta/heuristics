module Salesman

  class Base
    attr_reader :path, :cities, :distances, :total_distance

    def initialize(path)
      @path = path
    end

    def calculate!
      time "initialize_cities..." do
        initialize_cities
      end
      time "initialize_edges..." do
        initialize_edges
      end
      time "build_minimum_spanning_tree..." do
        build_minimum_spanning_tree
        puts "Tree edge distance: #{@tree.distance}"
      end
      time "build_minimum_matching_tree..." do
        build_minimum_matching_tree
        puts "Matching edge distance: #{@match.distance}"
        puts "Total distance: #{@tree.distance + @match.distance}"
      end
      time "travel_euler_tour..." do
        travel_euler_tour
      end
    end

    def total_distance
      puts "tour distance"
      @tour.distance
    end

    protected

    def time(msg = '', &block)
      t1 = Time.now
      puts msg
      yield
      t2 = Time.now
      puts Timer.diff(t1, t2)
    end

    def initialize_cities
      @cities = City.create_from_file(path)
    end

    def initialize_edges
      @edges  = Edge.create_from(@cities)
    end

    def build_minimum_spanning_tree
      @tree   = SpanTree.create_from(@cities, @edges)
    end

    def build_minimum_matching_tree
      @match  = MatchGraph.create_from(@tree.odd_cities, @edges)
    end

    def travel_euler_tour
      @tour   = EulerTour.travel!(@tree.edges, @match.edges)
    end
  end

  class Edge
    def self.create_from(cities)
      edges = []
      cities.each_with_index do |city, i|
        j = i + 1
        while j < cities.length
          edges << Edge.new(city, cities[j])
          j += 1
        end
      end
      edges.sort!
      edges
    end

    attr_reader :a, :b, :distance
    def initialize(a, b)
      @a = a
      @b = b
    end

    def <=>(edge)
      self.distance <=> edge.distance
    end

    def distance
      @distance ||= a.distance(b)
    end

    def cities
      [@a,@b]
    end
    
    def other(city)
      if city == a
        b
      elsif city == b
        a
      else
        nil
      end
    end

    def from_to
      cities.map(&:name)
    end

    def flip
      a1 = @a
      @a = @b
      @b = a1
      self
    end
  end

  class City

    def self.create_from_file(path)
      cities = []
      File.open(path, "r").readlines.each do |line|
        cities << City.new(*line.split(" ").map(&:to_i))
      end
      cities
    end

    attr_reader :name, :x, :y, :z
    def initialize(name, x, y, z)
      @name     = name
      @x      = x
      @y      = y
      @z      = z
    end

    def to_xyz
      [x, y, z]
    end

    def distance(city)
      Measure.distance(self.to_xyz, city.to_xyz).to_i
    end

  end
  
end