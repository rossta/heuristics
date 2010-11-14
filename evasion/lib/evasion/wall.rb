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
  end
end