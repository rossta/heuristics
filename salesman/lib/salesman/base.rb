module Salesman

  class Base
    attr_reader :path, :cities, :distances, :total_distance
    attr_accessor :tour, :tree, :match
    def initialize(path = nil)
      @path = path
    end

    def calculate!
      time "Loading file and initializing cities ..." do
        initialize_cities!
        puts " num of cities            : #{@cities.size}"
      end
      time "Initializing edges between each city pair ..." do
        initialize_edges!
        puts " num of edges             : #{@edges.size}"
      end
      time "Sorting edges..." do
        sort_edges!
      end
      time "Building minium spanning tree ..." do
        build_minimum_spanning_tree!
        puts " tree edge distance       : #{@tree.distance}"
      end
      time "Building graph of minimum matching edges ..." do
        build_minimum_matching_graph!
        puts " matching graph distance  : #{@match.distance}"
        puts " tree + matching distance : #{@tree.distance + @match.distance}"
      end
      time "Walking euler tour: visit every edge once ..." do
        travel_euler_tour!
        puts " euler tour distance      : #{@tour.distance}"
      end
      time "Optimizing for cities with multiple visits ..." do
        optimize_euler_tour!
      end
    end

    def total_distance
      return @tour.distance if @tour
      return @tree.distance + @match.distance if @tree && @match
      return @tree.distance if @tree
    end

    protected

    def time(msg = '', &block)
      t1 = Time.now
      puts msg
      yield
      t2 = Time.now
      puts " #{Timer.diff(t1, t2)}"
      print "\n"
    end

    def initialize_cities!
      @cities = City.create_from_file(path)
    end

    def initialize_edges!
      @edges  = Edge.create_from(@cities)
    end

    def sort_edges!
      @edges.sort!
    end

    def build_minimum_spanning_tree!
      @tree   = SpanTree.create_from(@cities, @edges)
    end

    def build_minimum_matching_graph!
      @match  = MatchGraph.create_from(@tree.odd_cities, @edges)
    end

    def travel_euler_tour!
      @tour   = EulerTour.travel(@tree.edges + @match.edges)
    end

    def optimize_euler_tour!
      @tour   = EulerTourOptimizer.optimize(@tour)
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