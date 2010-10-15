module Tipping

  class Player
    attr_accessor :blocks
    def initialize(game)
      @game   = game
      @blocks = (1..game.max_block).to_a
    end

    def next_move(message)
      depth = 1
      move = AlphaBeta.move(@game.position, depth)
      move
    end
  end

end