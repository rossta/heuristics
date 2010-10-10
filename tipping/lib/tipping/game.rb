module Tipping

  class Game

    def self.setup(opts)
      @@instance = new(opts)
    end

    def self.instance
      @@instance
    end

    attr_reader :range, :opponent_blocks, :player_blocks, :weight, :left_support, :right_support, :position, :player, :opponent

    def initialize(opts = {})
      @range      = opts[:range] || 15
      block_count = opts[:block_count] || 10
      @player     = Player.new(block_count)
      @opponent   = Player.new(block_count)
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

    def score(position)
      raise "Need to define Game#score of board method"
    end
    
    def locations
      @locations ||= (min..max).to_a
    end

    def available_moves(position)
      open_locations = locations.select { |l| position[l].nil? }
      
      @player.blocks.collect { |w|
        open_locations.collect { |l| Move.new(w, l, position) }
      }.flatten
    end
  end

end