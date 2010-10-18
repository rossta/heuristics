require 'rubygems'
require 'socket'
require 'tipping/alphabeta'
require 'tipping/player'
require 'tipping/game'
require 'tipping/position'
require 'tipping/torque'
require 'tipping/client'
require 'tipping/score'

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

  OPPONENT  = :opponent
  PLAYER    = :player
  FIRST     = :first
  SECOND    = :second

  FIRST_LOCATION = -4
  FIRST_WEIGHT = 3

  STRATEGIES = [
    TIPPERS       = "TIPPERS",
    CONSERVATIVE  = "CONSERVATIVE"
  ]

  class NoTipping

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
        when /^ADD/, /^REJECT/
          next_move = @player.next_move(response)
          @client.call(next_move.to_s)
        when /^REMOVE/
          next_move = @player.next_move(response)
          @client.call(next_move.to_s)

        when /^ACCEPT/
          @client.echo("Thank you")
        when /^WIN/, /^TIP/, /^LOSE/
          break
        else
          @client.echo("...waiting")
        end
      end

    end

    def player
      @player ||= @game.player
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
