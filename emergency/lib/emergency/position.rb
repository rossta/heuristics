module Emergency

  module Positioning

    def update_position(opts = {})
      position.x = opts[:x]
      position.y = opts[:y]
    end

    def position
      @position ||= Position.new
    end

    def position=(pos)
      @position = pos
    end

    def x
      position.x
    end

    def y
      position.y
    end
    
    def to_coord
      [x,y]
    end

  end

  class Position

    def self.center(pos_1, pos_2)
      x = ((pos_1.x - pos_2.x) / 2).to_i + pos_2.x
      y = ((pos_1.y - pos_2.y) / 2).to_i + pos_2.y
      Position.new(x, y)
    end

    attr_accessor :x, :y
    def initialize(x = nil, y = nil)
      @x = x; @y = y
    end
  end

end