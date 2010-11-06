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
      all_moves = @board.all_moves
      all_zones = @board.build_zones(50)
      best_move   = nil
      best_score  = 0
      100.times do
        move  = Move.new(rand(@size), rand(@size), @player_id)
        score = @board.score(@player_id, {
          :moves => (all_moves + [move]),
          :zones => all_zones
        })
        # puts "Move: #{move.to_coord.to_s}, score: #{score}"
        if score > best_score
          best_move = move
          best_score = score
        end
      end
      @board.add_move(best_move)
      best_move
    end
  end
end