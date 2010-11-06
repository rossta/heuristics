module Voronoi
  
  class Game
    attr_reader :board, :size, :moves, :players, :player_id
    def initialize(size, moves, players, player_id)
      @size       = size
      @moves      = moves
      @players    = players
      @player_id  = player_id
      @board      = Board.new({
        :size => [size,size],
        :players => 2
      })
    end
    
    def record_move(move)
      @board.add_move(move)
    end
  end
end