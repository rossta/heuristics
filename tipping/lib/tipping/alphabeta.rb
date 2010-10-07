module Tipping
  MAX_INT = 1000000
  MIN_INT = -1000000

  class AlphaBeta

    def self.score(state, a = MIN_INT, b = MAX_INT)

      return state.score if state.leaf?

      alpha = a
      beta  = b
      case state.turn
      when GameState::MIN
        state.children.each do |child|
          beta = [beta, AlphaBeta.score(child, alpha, beta)].min
          return alpha if alpha >= beta
        end
        return beta
      when GameState::MAX
        state.children.each do |child|
          alpha = [alpha, AlphaBeta.score(child, alpha, beta)].max
          return beta if alpha >= beta
        end
        return alpha
      else
        raise "Game state undefined"
      end
    end

  end

  class GameState
    MIN = :min
    MAX = :max

    attr_writer :children

    def self.min(children = nil)
      new(MIN, children)
    end

    def self.max(children = nil)
      new(MAX, children)
    end

    def initialize(turn, children)
      @turn = turn
      @children = children
    end

    def children
      @children ||= []
    end

    def score
      @score ||= 0
    end

    def turn
      @turn
    end

    def leaf?
      children.empty?
    end

    def min?
      @state == MIN
    end

    def max?
      @state == MAX
    end
  end
end

