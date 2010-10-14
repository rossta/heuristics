module Tipping

  class Torque

    def self.calc(weight, distance)
      (weight * distance).abs
    end

    def initialize(game)
      @game = game
    end

    def left(position)
      out_torque  = left_out_locations.inject(0) { |sum, i| sum += from_left(i, position) }
      in_torque   = left_in_locations.inject(0) { |sum, i| sum += from_left(i, position) } + left_board_torque
      out_torque - in_torque
    end

    def right(position)
      out_torque  = right_out_locations.inject(0) { |sum, i| sum += from_right(i, position) }
      in_torque   = right_in_locations.inject(0) { |sum, i| sum += from_right(i, position) } + right_board_torque
      out_torque - in_torque
    end

    def board(fulcrum)
      calc(@game.weight, fulcrum)
    end

    def calc(weight, distance)
      self.class.calc(weight, distance)
    end

    protected

    def left_out_locations
      @game.left_out_locations
    end
    
    def left_in_locations
      @game.left_in_locations
    end
    
    def right_out_locations
      @game.right_out_locations
    end
    
    def right_in_locations
      @game.right_in_locations
    end

    def from_left(location, position)
      calc(position[location].to_i, @game.left_support - location)
    end

    def from_right(location, position)
      calc(position[location].to_i, @game.right_support - location)
    end

    def left_board_torque
      @left_board_torque ||= calc(@game.weight, @game.left_support)
    end

    def right_board_torque
      @right_board_torque ||= calc(@game.weight, @game.right_support)
    end
  end

end