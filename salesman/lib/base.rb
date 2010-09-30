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
      @tree
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
      @parent = nil
    end

    def to_xyz
      [x, y, z]
    end

    def distance(city)
      Measure.distance(self.to_xyz, city.to_xyz).to_i
    end

  end

  class SpanTree
    attr_reader :size, :edges
    def self.build_from(cities, edges)
      new(cities, edges).build
    end

    def initialize(cities, source_edges)
      @cities         = cities
      @source_edges   = source_edges
      @edges          = []
      @size           = 0
      @in_mst         = {}
    end

    def build
      city_count = @cities.length
      add_city_to_mst(@cities.first)
      while @size < city_count
        edge = @source_edges.detect do |e|
          # XOR since we want cities and edges that connect to the tree but do not cycle
          in_mst?(e.a) ^ in_mst?(e.b)
        end

        @edges  << edge
        if !in_mst?(edge.a)
          add_city_to_mst(edge.a)
        elsif !in_mst?(edge.b)
          add_city_to_mst(edge.b)
        else
          raise "Tried to add double connected edge"
        end
      end
      self
    end

    def add_city_to_mst(city)
      @in_mst[city.name] = true
      @size += 1
      city
    end

    def in_mst?(city)
      @in_mst[city.name]
    end

    def distance
      @edges.inject(0) { |sum, e| sum += e.distance }
    end

  end

end