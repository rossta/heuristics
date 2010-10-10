module Tipping

  class Position
    MIN = :min
    MAX = :max

    attr_reader :board, :game

    def initialize(game = nil)
      @game  = game || Game.new
      @board = {}
    end

    def []=(location, weight)
      raise "Outside board boundary" if location > @game.max || location < @game.min
      raise "Location #{location} already contains weight #{weight}" unless @board[location].nil?
      @board[location] = weight
    end

    def [](location)
      @board[location]
    end

    def remove(location)
      @board[location] = nil
    end
    
    def available_moves
      @game.available_moves(self)
    end

    def current_score
      @game.score(self)
    end

  end

  class Move

    def initialize(weight, location, position)
      @weight   = weight
      @location = location
      @position = position
      @done = false
    end

    def <=>(move)
      self.score <=> move.score
    end

    def score
      @score ||= ensure_do && @position.current_score
    end

    def do
      @position[@location] = @weight
      @done = true
    end

    def undo
      @position.remove(@location)
      @done = false
    end

    def done?
      @done
    end

    protected

    def ensure_do
      self.do unless done?
    end
  end

end