module Voronoi
  class Move

    attr_reader :x, :y, :player_id
    attr_accessor :score, :zones
    def initialize(x,y,player_id)
      @x = x
      @y = y
      @player_id = player_id
      reset_zones!
    end

    def to_coord
      [x, y]
    end
    
    def reset_zones!
      @zones = []
    end
    
    def self.worst_move(player_id)
      move = new(0,0,player_id)
      move.score = 0
      move
    end

  end
end