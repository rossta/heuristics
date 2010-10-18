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

    attr_reader :range, :weight, :left_support, :right_support, :position, :player, :opponent, :max_block, :max_plies
    attr_accessor :phase, :strategy

    def initialize(opts = {})
      @range      = opts[:range] || 15
      @max_block  = opts[:max_block] || 10
      @weight           = opts[:weight] || 3
      @left_support     = opts[:left_support] || -3
      @right_support    = opts[:right_support] || -1
      @position   = Position.new(self)
      @player     = Player.new(self)
      @opponent   = Player.new(self)
      @debug      = opts[:debug] || true

      @max_plies  = @max_block * 2
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

    def score(player_type)
      current_player = send(player_type)
      multiplier = player_type == OPPONENT ? -1 : 1
      return -1 * multiplier if tipped?(position)

      case strategy
      when TIPPERS
        score = Score.tippers(self, player_type)
      else
        score = Score.conservative(self)
      end
      score * multiplier
    end

    def tipped?(position)
      torque.out(position) > 0 || torque.in(position) > 0
    end

    def locations
      @locations ||= (min..max).to_a
    end

    def available_moves(player_type)
      puts report(player_type) if debug?
      case phase
      when REMOVE
        position.board.collect { |l, w| Move.new(w, l, player_type) }
      else
        send(player_type).blocks.collect { |w|
          position.open_slots.collect { |l| Move.new(w, l, player_type) }
        }.flatten
      end
    end

    def debug?
      @debug
    end

    def do_move(move)
      case phase
      when REMOVE
        @position.remove(move.location)
      when ADD
        @position[move.location] = move.weight
        send(move.player_type).use_block(move.weight)
      else
        warn "Don't know how to do move"
      end
    end

    def undo_move(move)
      case phase
      when REMOVE
        @position[move.location] = move.weight
      when ADD
        @position.remove(move.location)
        send(move.player_type).replace_block(move.weight)
      else
        warn "Don't know how to undo move"
      end
    end

    def update_position(phase, locations)
      @phase = phase
      position.update_all(locations)
      case phase
      when ADD
        respond_to_add(locations)
      when REMOVE
        @strategy = TIPPERS
        puts "STRATEGY #{@strategy}"
      end
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

    def report(player_type, opts = {})
      state = [player_type.to_s.upcase]
      state << "Position: #{position}"
      state << "Blocks  : #{send(player_type).blocks.join("|")}" if phase == ADD
      state.join("\n")
    end

    def first_weight
      FIRST_WEIGHT
    end

    def first_location
      FIRST_LOCATION
    end

    protected

    def respond_to_add(locations)
      case locations.size
      when 1
        @player.turn    = FIRST
        @opponent.turn  = SECOND
      when 2
        @player.turn    = SECOND
        @opponent.turn  = FIRST
      end

      @strategy = if locations.size > max_plies - (max_block / 2)
        TIPPERS
      else
        CONSERVATIVE
      end
      puts "STRATEGY: #{@strategy}"

      locations.delete(FIRST_LOCATION)
      return unless locations.any?

      locations.delete_if { |loc, wt| @player.moved?(loc, wt) || @opponent.moved?(loc, wt) }
      warn "Locations unaccounted for!" unless locations.size == 1

      loc = locations.keys.first
      wt  = locations.values.first
      @opponent.add_move(Move.new(wt, loc, OPPONENT))
      if debug?
        puts report(OPPONENT)
        puts report(PLAYER)
      end
    end
  end

end