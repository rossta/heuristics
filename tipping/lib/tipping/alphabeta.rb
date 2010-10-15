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
        find_alpha_beta_move(move, depth, beta, local_alpha) do |alpha_beta_move|
          best_move = [
            best_move,
            alpha_beta_move
          ].max
        end

        break if best_move.score >= beta
        local_alpha = best_move.score if best_move.score > local_alpha
      end

      best_move
    end
    
    def self.find_alpha_beta_move(move, depth, beta, local_alpha)
      move.do
      alpha_beta_move = AlphaBeta.move(move.position, depth - 1, -beta, -local_alpha).inverse
      yield(alpha_beta_move)
      alpha_beta_move.inverse
      move.undo
    end

    protected

    def self.player_type_for(depth)
      depth % 2 == 0 ? PLAYER : OPPONENT
    end

  end

end

