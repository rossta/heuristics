module Tipping

  class Player
    attr_accessor :blocks, :best_score, :best_move, :move, :turn
    def initialize(game)
      @game   = game
      @blocks = (1..@game.max_block).to_a
      @moves  = []
    end

    def moved?(loc, wt)
      @moves.any? { |move| move.matches? loc, wt }
    end

    def use_block(weight)
      raise "Don't have block #{weight}" unless @blocks.include?(weight)
      @blocks.delete(weight)
    end

    def replace_block(weight)
      raise "Already have #{block}" if @blocks.include?(weight)
      @blocks << weight
      @blocks.sort!
    end

    def next_move(message)
      case message.first
      when ADD
        command, locations, torque = message

        @game.update_position(ADD, locations)
        depth = 2
        @best_score, @best_move = AlphaBeta.best_score(@game.position, depth)
        add_move(@best_move)

        @best_move
      when REMOVE
        command, locations, torque = message

        @game.update_position(REMOVE, locations)
        depth = 4
        @best_score, @best_move = AlphaBeta.best_score(@game.position, depth)

        @best_move
      when REJECT
        # handle weight already used
        # handle invalid weight
      else
        raise "Don't know what to do!"
      end
    end

    def blocks_to_s
      @blocks.join("|")
    end

    def add_move(move)
      @moves << move
      use_block(move.weight)
    end

    def remove_move(move)
      @moves.delete(move)
      replace_block(move.weight)
    end

  end

end