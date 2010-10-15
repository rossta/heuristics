module Tipping

  class Position
    MIN = :min
    MAX = :max

    attr_reader :board, :game
    attr_accessor :move

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

    def prepare!
      self[-4] = 3
    end

    def remove(location)
      @board[location] = nil
    end

    def available_moves(player_type)
      @game.available_moves(self, player_type)
    end

    def current_score(player_type)
      @game.score(self, player_type)
    end

    def open_slots
      @game.locations.select { |i| !@board.keys.include?(i) }
    end

    protected

  end

  class Move

    def self.worst_move
      @@worst_move ||= begin
        move = Move.new(nil, nil, nil, nil)
        move.score = MIN_INT
        move
      end
    end

    attr_accessor :score, :player_type, :position

    def initialize(weight, location, position, player_type)
      @weight   = weight
      @location = location
      @position = position
      @player_type = player_type
      @done = false
    end

    def <=>(move)
      self.score <=> move.score
    end

    def score
      @score ||= begin
        ensure_do
        @position.current_score(@player_type)
      end
    end

    def inverse
      @score = -score
      self
    end

    def do
      @position[@location] = @weight
      @position.move = self
      @done = true
    end

    def undo
      @position.move = nil
      @position.remove(@location)
      @done = false
    end

    def done?
      @done
    end

    def to_s
      [@weight, @location].join(",")
    end

    protected

    def ensure_do
      self.do unless done?
    end
  end

end