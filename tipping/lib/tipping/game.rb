module Tipping

  class Game

    def self.setup(opts)
      @@instance = new(opts)
    end

    def self.instance
      @@instance
    end

    attr_reader :range, :weight, :left_support, :right_support, :position, :player, :opponent

    def initialize(opts = {})
      @range      = opts[:range] || 15
      max_block   = opts[:max_block] || 10
      @player     = Player.new(max_block)
      @opponent   = Player.new(max_block)
      @weight           = opts[:weight] || 3
      @left_support     = opts[:left_support] || -3
      @right_support    = opts[:right_support] || -1
    end

    def position
      @position ||= Position.new(@game)
    end

    def min
      -@range
    end

    def max
      @range
    end

    def torque
      @torque ||= Torque.new(self)
    end

    def score(position, player_type)
      current_player = send(:player_type)
      raise "Need to define Game#score of board method"
    end

    def locations
      @locations ||= (min..max).to_a
    end

    def available_moves(position, player_type)
      open_locations = locations.select { |l| position[l].nil? }

      @player.blocks.collect { |w|
        open_locations.collect { |l| Move.new(w, l, position, player_type) }
      }.flatten
    end

    def complete_move(move, player)
      raise "not implemented"
    end
  end

end