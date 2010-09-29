module Salesman

  class Base
    attr_reader :path, :cities, :distances

    def initialize(path)
      @path = path
    end

    def calculate!
      initialize_cities
      initialize_edges
    end

    protected

    def initialize_cities
      @cities = City.create_from_file(path)
    end

    def initialize_edges
      @edges = []
      @tree = Containers::MinHeap.new

      cities.each_with_index do |city, i|
        j = i + 1
        @edges[i] = []
        while j < cities.length
          @edges[i] << Edge.new(city, cities[j])
          j += 1
        end
      end
      @edges
    end
  end

  class Edge
    attr_reader :a, :b, :distance
    def initialize(a, b)
      @a        = a
      @b        = b
    end
    
    def <=>(edge)
      self.distance <=> edge.distance
    end

    def distance
      @distance ||= Measure.distance(a.to_coord, b.to_coord).to_i
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

    attr_reader :number, :x, :y, :z
    def initialize(number, x, y, z)
      @number = number
      @x      = x
      @y      = y
      @z      = z
      @min    = 1000000
      @parent = nil
      @children = []
      @inheap = true
    end

    def to_coord
      [x, y, z]
    end
  end

end