require 'rubygems'
require 'socket'
require 'tipping/alphabeta'
require 'tipping/player'
require 'tipping/game'
require 'tipping/position'
require 'tipping/torque'
require 'tipping/client'

module Tipping

  COMMANDS = [
    ADD     = "ADD",
    REMOVE  = "REMOVE",
    ACCEPT  = "ACCEPT",
    REJECT  = "REJECT",
    TIP     = "TIP",
    WIN     = "WIN",
    LOSE    = "LOSE",
    TIMEOUT = "TIMEOUT"
  ]
  
  OPPONENT = :opponent
  PLAYER = :player

  class NoTipping
    ONE = :one
    TWO = :two

    def initialize(opts = {})
      @game   = Game.setup(opts)
      @player = @game.player
      @client = Client.new(opts)
    end

    def start!
      @client.connect

      @client.call(@client.name)
      
      sleep 1
      play_game

      @client.echo "Game over"
    end

    def player
      @game.player
    end

    def opponent
      @game.opponent
    end

    def play_game

      loop do
        response = @client.read
        case response.first
        when /^ADD/, /^REMOVE/, /^REJECT/
          next_move = @game.player.next_move(response)
          @client.call(next_move)
        when /^ACCEPT/
          @client.echo("Thank you")
        when /^WIN/, /^TIP/, /^LOSE/
          break
        else
          @client.echo("...waiting")
        end
      end

    end

  end
end


# loop
# if my_turn?
#   move = player.choose_move
#   client.send move
# else
#   client.receive_move
# end
# update_game_position
