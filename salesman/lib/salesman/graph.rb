module Salesman

  module EdgeDistance
    def distance
      @edges.inject(0) { |sum, e| sum += e.distance }
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
      @edge_count = {}
    end

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
      @edge_count[city.name] = count + 1
    end

    def edge_count(city)
      @edge_count[city.name].to_i
    end

  end

  class MatchGraph < Graph
    
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
      cities_names = @edge_count.keys.select { |name| @edge_count[name].odd? }
      cities_names.collect { |name| @cities.detect { |city| city.name == name } }
    end

  end

  class EulerTour
    include EdgeDistance
    
    def self.travel!(tree_edges, match_edges)
      new(tree_edges, match_edges).travel!
    end

    attr_reader :edges, :cities
    def initialize(tree_edges, match_edges)
      @tree_edges   = tree_edges
      @match_edges  = match_edges
    end

    def travel!
      match_edges = @match_edges
      @union_edges = @tree_edges + @match_edges
      @euler_edges = []
      @cities = []
      find_tour(@union_edges.first.a)
      @edges = @euler_edges
      self
    end

    def find_tour(a)
      a_edges = @union_edges.select { |e| e.cities.include?(a) }
      a_edges.each do |e|
        next unless @union_edges.include?(e)
        edge = @union_edges.delete_at(@union_edges.index(e))
        find_tour(e.other(a))
        @euler_edges << edge
      end
      @cities << a
    end

    def edge_count(city, edges)
      edges.map(&:from_to).flatten.group_by{|i| i }[city.name].to_a.size
    end

  end

end