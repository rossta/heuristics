class NoTipping

  def initialize(opts = {})
    @game   = Game.setup(opts)
    @client = Client.new(opts)
  end

  def start!
    @client.connect

    @client.call(@client.name)
    response = @client.read

    sleep 1
    play_game

    @client.echo "Game over"
  end

  def play_game
    loop do
      response = @client.read
      case response
      when /^(\d+) (\d+) (\d+)/
        # game state
        next_move = @player.next_move(response)
        @client.echo("move made: #{response}")
      when /^YOURTURN/
        # game state
        next_move = @player.next_move(response)
        @client.call(next_move.to_s)
      else
        @client.echo("...waiting")
      end
    end

  end

end