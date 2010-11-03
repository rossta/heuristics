module Voronoi
  attr_writer :debug
  class Dispatch
    attr_accessor :client, :game
    def initialize(opts = {})
      @client = Client.new({
        :host => opts[:host] || 'localhost',
        :port => (opts[:port] || 44444).to_i
      })
      @game   = nil
    end

    def start!
      @client.connect

      play_game

      @client.echo "Game over"
    end

    def play_game
      loop do
        response = @client.read
        case response
        when /^(\d+) (\d+) (\d+)/
          if @game
            x, y, player_id = format_number_response(response)
            @game.record_move(x, y, player_id)
          else
            moves, players, player_id = format_number_response(response)
            @game = Game.new(moves, players, player_id)
          end
        when /^YOURTURN/
          # game state
        else
          @client.echo("...waiting")
        end
        break if debug?
      end

    end

    def debug?
      self.class.debug?
    end

    @@debug = false
    def self.debug=(debug)
      @@debug = debug
    end
    def self.debug?
      @@debug
    end

    protected

    def format_number_response(response)
      response.split.map(&:to_i)
    end
  end
end