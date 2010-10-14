module Tipping
  class Server

    def initialize(port)
      begin
        @socket = TCPServer.new('localhost', port)
      rescue Exception => e
        puts e.message
      end
    end

    def listen
      @client = @socket.accept
      @client.puts "Connected"
      @client.flush
    end
    
    def send(message)
      @client.puts message
    end

    def stop!
      @client.close if !!@client
      @socket.close if !!@socket
    end
  end

end

def start_server(port)
  @server = Tipping::Server.new(port)
  yield @server
  @server.listen
  @server
end

def stop_server
  @server.stop! if !! @server
end