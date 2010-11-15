module Evasion
  class Wall
    attr_accessor :name, :x_1, :y_1, :x_2, :y_2
    def initialize(name, x_1, y_1, x_2, y_2)
      @name = name
      @x_1 = x_1
      @y_1 = y_1
      @x_2 = x_2
      @y_2 = y_2
    end

    def orientation
      @orientation ||= begin
        if @x_1 == @x_2
          :vertical
        elsif @y_1 == @y_2
          :horizontal
        else
          raise "illegal wall!"
        end
      end
    end

    def intersects?(x, y)
      case orientation
      when :horizontal
        @y_1 == y && @y_2 == y
      when :vertical
        @x_1 == x && @x_2 == x
      else
        false
      end
    end
    
    def to_coord
      coord_1 = [@x_1, @y_1]
      coord_2 = [@x_2, @y_2]
      "#{@name} (#{coord_1.join(', ')}), (#{coord_2.join(', ')})"
    end
  end
end