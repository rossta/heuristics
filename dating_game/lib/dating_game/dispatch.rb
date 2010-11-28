module DatingGame
  class InvalidPlayerNameError < RuntimeError
  end

  class Dispatch
    attr_accessor :client, :game, :name

    VALID_PLAYERS = [
      PERSON = 'Person',
      MATCHMAKER = 'Matchmaker'
    ]

    def initialize(opts = {})
      @client = Connection::Client.new({
        # access.cims.nyu.edu:20000
        :host => opts[:host] || 'localhost',
        :port => (opts[:port] || 20000).to_i
      })
      @name   = opts[:name] || 'Person'
      if !VALID_PLAYERS.include? @name
        raise InvalidPlayerNameError.new("#{@name} given; must use #{VALID_PLAYERS.join(' or ')}")
      end
      @game   = nil
    end

    def start!
      @client.connect

      @client.call(@name)

      play_game

      @client.disconnect
    end

    def play_game
      case @name
      when PERSON
        @player = Person.new
        play_person
      when MATCHMAKER
        play_matchmaker
      end
    end

    def play_person
      loop do
        response = @client.read
        case response
        when /#{PERSON}/
          # accepted connection
        when /N:\s*\d+/
          label, count = response.split(":")
          file_name = @player.generate_person_file(count)
          @client.call file_name
        when /VALID ATTRIBUTES/
          break
        end
      end
    end

    def play_matchmaker
      loop do
        response = @client.read
        case response
        when /#{MATCHMAKER}/
        when /N:\s*\d+/
          file_name = File.expand_path(File.dirname(__FILE__)) + "/../../data/Person.txt"
          @client.call file_name
        when /VALID ATTRIBUTES/
          break
        end
      end
    end
    
  end
end