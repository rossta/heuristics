require 'socket'

module Echo
  class Server
    def initialize(host, port)
      @host = host || '127.0.0.1'
      @port = port || 44444

      begin
        @server = TCPServer.new(@host, @port)
      rescue Exception => e
        puts e.message
      end
    end

    def start!
      begin
        puts "Waiting for client on port #{@port}"
        client = @server.accept
        puts "Client connected"
        while message = STDIN.gets
          client.puts message
          puts client.readline
        end
        client.close
      rescue Exception => e
        puts "Error while attempting to connect to port #{port}"
        puts e.message
      end
    end
  end
end