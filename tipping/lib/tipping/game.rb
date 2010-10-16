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
    attr_accessor :condition

    def initialize(opts = {})
      @range      = opts[:range] || 15
      @max_block  = opts[:max_block] || 10
      @weight           = opts[:weight] || 3
      @left_support     = opts[:left_support] || -3
      @right_support    = opts[:right_support] || -1
      @position   = Position.new(self)
      @player     = Player.new(self)
      @opponent   = Player.new(self)
      @condition  = ADD
      @debug      = opts[:debug] || false
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

      return -1 * multiplier if tipped?(position)
      score = locations.inject(0) { |sum, loc|
        sum += position[loc].to_i * ((left_support - loc).abs + (right_support - loc).abs)
      }
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
      send(player_type).blocks.collect { |w|
        position.open_slots.collect { |l| Move.new(w, l, player_type) }
      }.flatten
    end
    
    def debug?
      
    end

    def do_move(move)
      @position[move.location] = move.weight
      send(move.player_type).use_block(move.weight)
    end

    def undo_move(move)
      @position.remove(move.location)
      send(move.player_type).replace_block(move.weight)
    end

    def update_position(locations)
      position.update_all(locations)
      case condition
      when ADD
        case locations.size
        when 1
          @player.turn    = FIRST
          @opponent.turn  = SECOND
          @first_location = locations.keys.first
        when 2
          @player.turn    = SECOND
          @opponent.turn  = FIRST
        end
        locations.delete(@first_location)
        return unless locations.any?
        @debug = true

        turn = locations.size % 2 == 0 ? FIRST : SECOND
        locations.delete_if { |loc, wt|
          @player.moved?(loc, wt) || @opponent.moved?(loc, wt)
        }

        warn "Locations unaccounted for!" unless locations.size == 1
        loc = locations.keys.first
        wt  = locations.values.first
        @opponent.add_move(Move.new(wt, loc, OPPONENT))
        puts "OPPONENT BLOCKS       : #{@opponent.blocks_to_s}"
        puts "send :opponent blocks : #{send(:opponent).blocks_to_s}"
        puts "PLAYER BLOCKS         : #{@player.blocks_to_s}"
        puts "send :opponent blocks : #{send(:player).blocks_to_s}"
      when REMOVE
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
    
    def report(player_type)
      state = ["Available moves for #{player_type.to_s.upcase}"]
      state << "Position: #{position}"
      state << "Blocks  : #{send(player_type).blocks.join("|")}"
      state.join("\n")
    end
  end

end