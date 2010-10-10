module Tipping

  class Player
    ONE = :one
    TWO = :two

    def initialize(opts = {})
      @turn   = opts.delete(:turn) || ONE
      @game   = Game.setup(opts)
      @client = Client.new(opts)
    end

    def play!
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

end