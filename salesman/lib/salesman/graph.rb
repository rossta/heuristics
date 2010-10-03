module Salesman

  class Graph
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

    def distance
      @edges.inject(0) { |sum, e| sum += e.distance }
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
      last_edge   = match_edges.pop
      union_edges = @tree_edges + match_edges
      euler_edges = []

      edge = union_edges.detect { |e| e.cities.include?(last_edge.b) }
      edge.flip if edge.a != last_edge.b

      euler_edges << union_edges.delete(edge)
      while union_edges.any?
        prev_edge = edge
        edge = union_edges.detect { |e| e.cities.include?(prev_edge.b) && !e.cities.include?(last_edge.a) }
        if edge.nil?
          edge = union_edges.first
          raise "Last edge found not end of path #{edge.from_to.join(',')}" if !edge.cities.include?(last_edge.a)
        end
        edge.flip if edge.a != prev_edge.b
        euler_edges << union_edges.delete(edge)
      end
      @edges = euler_edges
      @cities = @edges.map(&:a) + [@edges.last.b]
    end
  end

end