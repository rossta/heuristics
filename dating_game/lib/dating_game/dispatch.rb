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
        @person = Person.new
        play_person
      when MATCHMAKER
        @matchmaker = Matchmaker.new
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
          label, count = response.split(DELIM)
          file_name = @person.generate_person_file(count)
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
          # accepted coppected
        when /N:\s*\d+/
          label, count = response.split(DELIM)
          @matchmaker.attr_count = count.to_i
          # @client.call @matchmaker.next_candidate
        when /^\-?\d+\.\d+\:/
          @matchmaker.parse_candidate(*response.split(DELIM))
        when /SCORE:0:0:0/
          can = @matchmaker.next_candidate
          @client.call can.to_msg
        when /SCORE/
          label, last_score, total_score, attempts = response.split(DELIM)
          @matchmaker.candidates.last.score = last_score.to_f
          can = @matchmaker.next_candidate
          @client.call can.to_msg
        when /^FINAL SCORE/
          @client.echo response
        when /DISCONNECT/
          break
        end
      end
    end

  end
end