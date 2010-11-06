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
    
    def record_move(x, y, player_id)
      move = Move.new(x, y, player_id)
      @board.add_move(move)
      move
    end
    
    def find_and_record_next_move
      move = Move.new(rand(@size), rand(@size), @player_id)
      @board.add_move(move)
      move
    end
  end
end