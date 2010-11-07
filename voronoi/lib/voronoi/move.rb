module Voronoi
  class Move

    attr_reader :x, :y, :player_id
    attr_accessor :score
    def initialize(x,y,player_id)
      @x = x
      @y = y
      @player_id = player_id
    end

    def to_coord
      [x, y]
    end
    
    def self.worst_move
      move = new(0,0,nil)
      move.score = 0
      move
    end

  end
end