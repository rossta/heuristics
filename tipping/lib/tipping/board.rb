module Tipping

  class Board
    attr_reader :length, :opponent_blocks, :player_blocks, :weight,
      :left_support, :right_support

    def initialize(opts = {})
      @length = opts[:length] || 30
      blocks  = opts[:blocks] || 10
      @player_blocks   = (1..blocks).to_a
      @opponent_blocks = (1..blocks).to_a
      @weight =   opts[:weight] || 3
      @left_support = opts[:left_support] || -3
      @right_support = opts[:right_support] || -1
    end

    def position
      @position ||= Position.new(@length)
    end

    def place(weight)
      placer.weight = weight
      placer
    end

    def left_torque
      out_torque = (position.min..left_support - 1).to_a.inject(0) { |sum, i| 
        sum += torque(i, left_support) 
      }
      in_torque = (left_support + 1..position.max).to_a.inject(0) { |sum, i| 
        sum += torque(i, left_support)
      } + board_torque(left_support)
      out_torque - in_torque
    end

    def right_torque
      out_torque = (position.min..right_support - 1).to_a.inject(0) { |sum, i| sum += torque(i, right_support) }
      in_torque = (right_support + 1..position.max).to_a.inject(0) { |sum, i| sum += torque(i, right_support) } + board_torque(right_support)
      out_torque - in_torque
    end
    
    def torque(location, fulcrum)
      distance = (fulcrum - location).abs
      position[location].to_i * distance
    end
    
    def board_torque(fulcrum)
      fulcrum.abs * @weight
    end

    protected

    def placer
      @placer ||= Placer.new(position)
    end

    class Placer
      attr_accessor :weight
      def initialize(position)
        @position = position
      end
      def at(location)
        @position[location] = @weight
      end
    end

  end

  class Position
    def initialize(length)
      @length = length
      @placement = {}
    end

    def []=(location, weight)
      raise "Location #{location} not found on board" if location > max || location < min
      if @placement[location].nil?
        @placement[location] = weight
      else
        raise "Location #{location} already contains weight #{weight}"
      end
    end

    def [](location)
      @placement[location]
    end

    def max
      @length / 2
    end

    def min
      -max
    end

  end

end