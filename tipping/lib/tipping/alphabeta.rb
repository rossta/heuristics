module Tipping
  MAX_INT = 1000000
  MIN_INT = -1000000

  class AlphaBeta

    def self.score(state, a = MIN_INT, b = MAX_INT)

      return state.score if state.leaf?

      alpha = a
      beta  = b
      case state.player
      when Player::MIN
        state.successors.each do |s|
          beta = [beta, AlphaBeta.score(s, alpha, beta)].min
          return alpha if alpha >= beta
        end
        return beta
      when Player::MAX
        state.successors.each do |s|
          alpha = [alpha, AlphaBeta.score(s, alpha, beta)].max
          return beta if alpha >= beta
        end
        return alpha
      else
        raise "Game state undefined"
      end
    end

  end

  class GameState

    attr_accessor :successors

    def self.min(successors = nil)
      new(Player::MIN, successors)
    end

    def self.max(successors = nil)
      new(Player::MAX, successors)
    end

    def initialize(player, successors)
      @player = player
      @successors = successors || []
    end

    def score
      @score ||= 0
    end

    def player
      @player
    end

    def leaf?
      successors.empty?
    end

    def min?
      @state == MIN
    end

    def max?
      @state == MAX
    end
  end
end

