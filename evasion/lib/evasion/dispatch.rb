module Evasion
  attr_writer :debug
  class Dispatch
    attr_accessor :client, :game
    def initialize(opts = {})
      @client = Connection::Client.new({
        :host => opts[:host] || 'localhost',
        :port => (opts[:port] || 44444).to_i
      })
      @game   = nil
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
        @client.call "You said: #{response}"
      end
    end
    protected
  end
end