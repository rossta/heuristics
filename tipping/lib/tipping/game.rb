module Tipping

  class Game

    def self.setup(opts)
      @@instance = new(opts)
    end

    def self.instance
      @@instance
    end
    
    def self.left_support
      instance.left_support
    end
    
    def self.right_support
      instance.right_support
    end
    
    def self.min
      instance.min
    end
    
    def self.max
      instance.max
    end
    
    def self.weight
      instance.weight
    end
    
    def self.score(board)
      instance.score(board)
    end

    attr_reader :length, :opponent_blocks, :player_blocks, :weight, :left_support, :right_support, :position

    def initialize(opts = {})
      @length = opts[:length] || 30
      blocks  = opts[:blocks] || 10
      @player_blocks    = (1..blocks).to_a
      @opponent_blocks  = (1..blocks).to_a
      @weight           = opts[:weight] || 3
      @left_support     = opts[:left_support] || -3
      @right_support    = opts[:right_support] || -1
    end

    def position
      @position ||= Position.new(@length)
    end

    def min
      @min ||= -max
    end

    def max
      @max ||= @length / 2
    end
    
    def torque
      @torque ||= Torque.new(self)
    end
    
    def score(board)
      raise "Need to define Game#score of board method"
    end
  end

end