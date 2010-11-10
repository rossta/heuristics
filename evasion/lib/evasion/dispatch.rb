module Evasion
  attr_writer :debug
  class Dispatch
    attr_accessor :client, :game
    def initialize(opts = {})
      @client = Connection::Client.new({
        # access.cims.nyu.edu:23000
        :host => opts[:host] || 'localhost',
        :port => (opts[:port] || 23000).to_i
      })
      @name   = opts[:name] || 'Rossta'
      @game   = nil
      @debug  = opts[:debug] || false
    end

    def start!
      @client.connect

      @client.call("JOIN #{@name}")

      play_game

      @client.echo "Game over"
      @client.disconnect
    end

    def play_game
      loop do
        response = @client.read
        case response
        when /ACCEPTED/
          role = response.chomp.upcase.split[1]
          @game = Game.new(:role => role)
          # determines HUNTER or PREY
        when /\(\d+, \d+\) \d+, \d+, \d+/
          # game parameters
          # (xDimension, yDimension) wallCount, wallCooldown, preyCooldown
          # Example: (500,500) _TBD_, _TBD25-50_, 1
          params = match_game_params(response)
          @game.width         = params[:width]        
          @game.height        = params[:height]       
          @game.wall_count    = params[:wall_count]   
          @game.wall_cooldown = params[:wall_cooldown]
          @game.prey_cooldown = params[:prey_cooldown]

        when /YOURTURN/
          # Receive game state
          # YOURTURN _ROUNDNUMBER_ H(x, y, cooldown, direction), P(x, y, cooldown), W[wall_one, wall_two]
          # wall: (id, x1, y1, x2, y2)
          # params = match_turn_params(response)
          params = {}.tap do |p|
            hunter_match  = response.match(/H\(([^\)]+)\)/)[1]
            prey_match    = response.match(/P\(([^\)]+)\)/)[1]
            wall_match    = response.match(/W\[([^\]]+)\]/)[1]
            p[:round]  = response.match(/YOURTURN (\d+)/)[1].to_i
            p[:hunter] = hunter_match.gsub(" ", "").split(",").map { |v| v =~ /\d+/ ? v.to_i : v }
            p[:prey]   = prey_match.gsub(" ", "").split(",").map(&:to_i)
            # params[:walls]  = wall_match.
          end
          @game.turn = params[:round]
          @game.update_hunter(*params[:hunter])
          @game.update_prey(*params[:prey])
          # Hunter Requests
          # PASS
          # ADD _WALL_ID_ (x1, y1), (x2, y2)  : create wall
          # REMOVE _WALL_ID_                  : remove wall

          # Prey Requests
          # PASS
          # N | S | E | W | NW | NE | SE | SW   : move on a vector
          # X, Y                                : new coords

        when /GAMEOVER/
          # GAMEOVER _ROUNDNUMBER_ WINNER _ROLE_ _REASON_
          # or
          # GAMEOVER _ROUNDNUMBER_ LOSER _ROLE_ _REASON_
          break
        else
        end
        @client.call "You said: #{response}"
        break if debug?
      end
    end

    def debug?
      @debug
    end
    
    protected
    
    def match_game_params(response)
      matches = response.chomp.match(/\((\d+),\s+(\d+)\)\s+(\d+),\s+(\d+),\s+(\d+)/)
      {}.tap do |params|
        params[:width]          = matches[1].to_i
        params[:height]         = matches[2].to_i
        params[:wall_count]     = matches[3].to_i
        params[:wall_cooldown]  = matches[4].to_i
        params[:prey_cooldown]  = matches[5].to_i
      end
    end
  end
end