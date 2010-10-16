module Tipping

  class Position
    MIN = :min
    MAX = :max

    attr_reader :board, :game
    attr_accessor :move, :best_move

    def initialize(game)
      @game  = game
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
    
    def clear
      @board.clear
    end

    def remove(location)
      @board.delete(location)
    end

    def available_moves(player_type)
      @game.available_moves(player_type)
    end

    def do!(move)
      @game.do_move(move)
    end

    def undo!(move)
      @game.undo_move(move)
    end

    def current_score(player_type)
      @game.score(self, player_type)
    end

    def tipped?
      @game.tipped?(self)
    end

    def open_slots
      @game.locations.select { |i| !@board.keys.include?(i) }
    end

    def to_s
      (@game.min..@game.max).to_a.map { |i| @board[i] }.join("|")
    end

    def update_all(locations)
      return unless locations.is_a?(Hash)
      clear
      locations.each do |loc, wt|
        self[loc] = wt
      end
    end

    protected

  end

  class Move

    attr_accessor :score, :player_type, :location, :weight

    def initialize(weight, location, player_type = nil)
      @weight   = weight
      @location = location
      @player_type = player_type
      @done = false
    end
    
    def matches?(location, weight)
      @location == location && @weight == weight
    end
    
    def to_s
      [@weight, @location].join(",")
    end

  end

end