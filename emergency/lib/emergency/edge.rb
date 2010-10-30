module Emergency

  class Edge
    @@all = []

    def self.all
      @@all
    end

    def self.find(a, b)
      edge = @@all.detect { |e| e.matches?(a, b) }
      edge = add(a,b) if edge.nil?
      edge
    end

    def self.add(a, b)
      edge = Edge.new(a, b)
      @@all << edge
      edge
    end

    attr_accessor :a, :b, :count

    def initialize(a, b)
      @a = a
      @b = b
      @count = 0
    end

    def distance
      @distance ||= a.distance_to b
    end
    
    def matches?(a, b)
      @a.same?(a) && @b.same?(b) || @a.same?(b) && @b.same?(a)
    end

  end
end