module Tipping

  class Position
    MIN = :min
    MAX = :max

    attr_accessor :board

    def initialize
      @board = {}
    end

    def []=(location, weight)
      @board[location] = weight
    end

    def [](location)
      @board[location]
    end

    def place(weight)
      Placer.new(self, weight)
    end

    class Placer
      attr_accessor :weight
      def initialize(position, weight)
        @position = position
        @weight = weight
      end

      def at(location)
        raise "Outside board boundary" if location > Game.max || location < Game.min
        raise "Location #{location} already contains weight #{weight}" unless @position[location].nil?
        @position[location] = @weight
      end
    end
  end
end