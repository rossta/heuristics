module Tipping
  MAX_INT = 1000000
  MIN_INT = -1000000

  class AlphaBeta

    def self.move(position, depth, alpha = MIN_INT, beta = MAX_INT)
      return position.move if depth == 0

      best_move   = Move.worst_move
      local_alpha = alpha
      player_type = player_type_for(depth)

      position.available_moves(player_type).each do |move|
        move.do if move.respond_to?(:do)
        best_move = [
          best_move,
          -AlphaBeta.move(move.position, depth - 1, -beta, -local_alpha)
        ].max
        move.undo if move.respond_to?(:undo)

        break if best_move >= beta
        local_alpha = best_move if best_move > local_alpha
      end

      best_move
    end

    protected

    def self.player_type_for(depth)
      depth % 2 == 0 ? PLAYER : OPPONENT
    end

  end

end

