module Tipping

  class Game

    def self.setup(opts)
      @@instance = new(opts)
    end

    def self.instance
      @@instance
    end

    def self.position
      @@instance.position if @@instance
    end

    attr_reader :range, :weight, :left_support, :right_support, :position, :player, :opponent, :max_block

    def initialize(opts = {})
      @range      = opts[:range] || 15
      @max_block  = opts[:max_block] || 10
      @weight           = opts[:weight] || 3
      @left_support     = opts[:left_support] || -3
      @right_support    = opts[:right_support] || -1
      @player     = Player.new(self)
      @opponent   = Player.new(self)
    end

    def position
      @position ||= begin
        position = Position.new
        position.prepare!
        position
      end
    end

    def min
      - max
    end

    def max
      @range
    end

    def torque
      @torque ||= Torque.new(self)
    end

    def score(position, player_type)
      current_player = send(player_type)
      multiplier = player_type == OPPONENT ? -1 : 1
      return -1 * multiplier if torque.out(position) > 0
      return -1 * multiplier if torque.in(position) > 0
      score = locations.inject(0) { |sum, loc|
        sum += position[loc].to_i * ((left_support - loc).abs + (right_support - loc).abs)
      }
      score * multiplier
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

    def left_out_locations
      @left_out_locations ||= (min..left_support - 1).to_a
    end

    def left_in_locations
      @left_in_locations ||= (left_support + 1..max).to_a
    end

    def right_out_locations
      @right_out_locations ||= (min..right_support - 1).to_a
    end

    def right_in_locations
      @right_in_locations ||= (right_support + 1..max).to_a
    end
  end

end