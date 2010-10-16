module Tipping
  MAX_INT = 1000000
  MIN_INT = -1000000

  class AlphaBeta

    def self.best_score(position, depth, alpha = MIN_INT, beta = MAX_INT)
      player_type = player_type_for(depth)
      return position.current_score(player_type) if depth == 0

      available_moves = position.available_moves(player_type)
      local_alpha = alpha
      best_value  = MIN_INT
      best_move   = available_moves.first

      # return -INFINITY if position.win?
      # handlenomove(position) if position.available_moves(player_type).empty?
      available_moves.each do |move|
        position.do! move
        if position.tipped?
          position.undo! move
          next
        end
        value, later_move = AlphaBeta.best_score(position, depth - 1, -beta, -local_alpha)
        value = -value
        position.undo! move
        best_value  = [best_value, value].max
        best_move   = move if best_value == value
        break if (best_value >= beta)
        local_alpha = best_value if best_value > local_alpha
      end
      puts [best_value, best_move].join(", ") if Game.instance.debug?
      [best_value, best_move]
    end

    protected

    def self.player_type_for(depth)
      depth % 2 == 0 ? PLAYER : OPPONENT
    end

  end

end

