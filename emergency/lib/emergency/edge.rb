module Emergency

  class Edge
    PHEROME_CONSTANT = 9

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

    def self.counter
      @@counter ||= []
    end
    
    def self.increment_all
      counter.each { |e| e.increment_count }
    end

    def self.reset
      @@counter = []
    end

    def self.create_from(positions)
      @@all = []
      positions.each_with_index do |pos, i|
        j = i + 1
        while j < positions.length
          other = positions[j]
          edge = Edge.new(pos, other)
          pos.edges << edge
          other.edges << edge
          @@all << edge
          j += 1
        end
      end
      @@all
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

    def other(pos)
      a if pos == b
      b if pos == a
    end

    def weighted
      Array.new(count.to_i + 1, self)
    end

    def increment_count
      @count += 1
    end

  end
end