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
          @count = count.to_i
          file_desc = "PersonX.txt"
          file_path = File.expand_path(File.dirname(__FILE__)) + "/../../data/"
          file = File.open(file_path + file_desc, "w+")
          
          up = @count / 2
          dn = @count - up
          weights = up_weights(up) + down_weights(dn)
          while !weights.empty?
            index   = rand(weights.size)
            weight  = weights.delete_at(index)
            file.puts weight
          end
          file.close

          @client.call "./../data/#{file_desc}"
        when /VALID ATTRIBUTES/
          break
        end
      end
    end

    def up_weights(count)
      ups = [].tap { |arr| count.times { arr << rand(100) } }
      sum = ups.inject(&:+)
      while (sum != 100)
        index = rand(ups.size)
        val = ups[index]
        if sum > 100
          val = val - 1
          ups[index] = val if val > 1 && !ups.include?(val)
        else
          val = val + 1
          ups[index] = val if val < 100 && !ups.include?(val)
        end
        sum = ups.inject(&:+)
      end
      ups.map { |v| v.to_f / 100 }
    end
    
    def down_weights(count)
      downs = [].tap { |arr| count.times { arr << -rand(100) } }
      sum = downs.inject(&:+)
      while (sum != -100)
        index = rand(downs.size)
        val = downs[index]
        if sum > -100
          val = val - 1
          downs[index] = val if val > -100 && !downs.include?(val)
        else
          val = val + 1
          downs[index] = val if val < 1 && !downs.include?(val)
        end
        sum = downs.inject(&:+)
      end
      downs.map { |v| v.to_f / 100 }
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