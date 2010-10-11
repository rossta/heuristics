module Tipping
  
  class Referee
    ONE = :one
    TWO = :two

    def initialize(opts = {})
      @turn   = opts.delete(:turn) || ONE
      @game   = Game.setup(opts)
      @client = Client.new(opts)
    end

    def begin!
      # loop
      # if my_turn?
      #   move = player.choose_move
      #   client.send move
      # else
      #   client.receive_move
      # end
      # update_game_position
    end
  end
  
  class Player
    attr_accessor :blocks
    def initialize(max_block)
      @blocks = (1..max_block).to_a
    end
  end
  
end