module Salesman

  module EdgeDistance
    def distance
      @edges.inject(0) { |sum, e| sum += e.distance }
    end
  end

  module GraphBuilder

    def in_tree?(city)
      edge_count(city) > 0
    end

    def add_edge(edge)
      increment_edge_count(edge.a)
      increment_edge_count(edge.b)
      @edges  << edge
      edge
    end

    def increment_edge_count(city)
      count = edge_count(city)
      @size += 1 if count.zero?
      @edge_counter[city.name] = count + 1
    end

    def edge_count(city)
      @edge_counter[city.name].to_i
    end
  end

  class Graph
    include EdgeDistance

    def self.create_from(cities, source_edges)
      new(cities, source_edges).build
    end

    attr_reader :size, :cities, :edges
    def initialize(cities, source_edges)
      @cities     = cities
      @source_edges = source_edges
      @edges      = []
      @size       = 0
      @edge_counter = {}
    end

  end

  class MatchGraph < Graph
    include GraphBuilder
    def build
      @cities.each_with_index do |city, i|
        next unless edge_count(city).zero?
        j         = i + 1
        edge = @source_edges.detect do |e|
          (edge_count(city).zero?) && (city == e.a && @cities.include?(e.b)) && (edge_count(e.b).zero?)
        end
        add_edge(edge) unless edge.nil?
      end
      # puts "odd cities #{@cities.size}, match edges: #{@edges.size}"
      self
    end

  end

  class SpanTree < Graph
    include GraphBuilder
    def build
      city_count    = @cities.size
      add_edge @source_edges.first
      while @size < city_count
        edge = @source_edges.detect do |e|
          # XOR since we want cities and edges that connect to the tree but do not cycle
          in_tree?(e.a) ^ in_tree?(e.b)
        end
        add_edge(edge)
      end
      # puts "cities #{@cities.size}, match edges: #{@edges.size}"
      self
    end

    def odd_cities
      cities_names = @edge_counter.keys.select { |name| @edge_counter[name].odd? }
      cities_names.collect { |name| @cities.detect { |city| city.name == name } }
    end

  end

  class EulerTour < Graph

    def self.travel(edges)
      new(edges).travel
    end

    attr_reader :edges, :cities
    def initialize(edges)
      super(nil, edges)
      @cities = []
    end

    def travel
      find_tour(@source_edges.first.a)
      self
    end

    def find_tour(a)
      a_edges = @source_edges.select { |e| e.cities.include?(a) }
      a_edges.each do |e|
        next unless @source_edges.include?(e)
        edge = @source_edges.delete_at(@source_edges.index(e))
        find_tour(e.other(a))
        @edges << edge
      end
      @cities << a
    end

    def edge_count(city, edges)
      edges.map(&:from_to).flatten.group_by{|i| i }[city.name].to_a.size
    end

  end

  class EulerTourOptimizer < Graph

    def self.optimize(tour)
      new(tour.cities, tour.edges).optimize
    end

    def initialize(cities, edges)
      super
      @edges = @source_edges
    end

    attr_reader :cities, :edges

    def optimize
      indexes = {}
      @cities.each_with_index do |city, i|
        indexes[city] ||= []
        indexes[city] << i
      end
      uniq_cities = @cities.uniq
      marked = []
      uniq_cities.each do |city|
        inds = indexes[city]
        next unless inds && inds.size > 1
        next if city == @cities.last
        distances = inds.map { |i| @edges[i].distance + @edges[i + 1].distance }
        marked << inds[distances.index(distances.min)]
      end
      marked.each do |i|
        @cities[i] = nil
      end
      @cities.compact!
      @edges = []
      @cities.each_with_index do |city, i|
        if next_city = @cities[i + 1]
          @edges << Edge.new(city, next_city)
        end
      end
      self
    end

    def find_cities_with_multiple_visits
      @cities.group_by {|i|i}.select{|k,v| v.size > 1 }.map(&:first)
    end
  end

end