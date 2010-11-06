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
      self.class.debug   = opts[:debug] || false
    end

    def start!
      @client.connect

      play_game

      @client.echo "Game over"
      sleep 4
      @client.disconnect
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
            size, moves, players, player_id = format_number_response(response)
            @game = Game.new(size, moves, players, player_id)
          end
          @client.call("OK")
        when /^YOURTURN/
          move = @game.find_and_record_next_move
          @client.call(move.to_coord.join(" "))
        when /^WIN/
          @client.echo("I win! I AM THE GREATEST!")
          break
        when /^LOSE/
          @client.echo("I lost? Damn those confounded kids!")
          break
        else
          response
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