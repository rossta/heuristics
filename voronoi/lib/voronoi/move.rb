module Voronoi
  class Move

    attr_reader :x, :y, :player_id
    def initialize(x,y,player_id)
      @x = x
      @y = y
      @player_id = player_id
    end

    def to_coord
      [x, y]
    end

  end
end