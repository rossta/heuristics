module Salesman

  class Base
    attr_reader :path, :cities, :distances, :total_distance

    def initialize(path)
      @path = path
    end

    def calculate!
      t1 = Time.now
      puts "initialize_cities..."
      initialize_cities
      t2 = Time.now
      puts Timer.diff(t1, t2)
      puts "initialize_edges..."
      initialize_edges
      t3 = Time.now
      puts Timer.diff(t2, t3)
      puts "build_minimum_spanning_tree..."
      build_minimum_spanning_tree
      t4 = Time.now
      puts Timer.diff(t3, t4)
      puts "build_minimum_matching_tree..."
      build_minimum_matching_tree
      t5 = Time.now
      puts Timer.diff(t4, t5)
    end

    def total_distance
      @tree.distance
    end

    protected

    def initialize_cities
      @cities = City.create_from_file(path)
    end

    def initialize_edges
      @edges = Edge.build_from(@cities)
    end

    def build_minimum_spanning_tree
      @tree = SpanTree.build_from(@cities, @edges)
    end

    def build_minimum_matching_tree
      @match = MatchTree.build_from(@tree.odd_cities, @edges)
    end
  end

  class Edge
    def self.build_from(cities)
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