module Tipping
  class Server
    
    def initialize
      begin
        @socket = TCPServer.new('localhost', port)
      rescue Exception => e
        puts e.message
      end
    end
    
    def listen
      @client = @socket.accept
      handle(client)
    end
    
    def handle(client)
      
    end
    
    def stop!
      @client.close
      @socket.close
    end
  end
  
end

def start_server
  @server = Tipping::Server.new(4445)
  @server.listen
end

def stop_server
  @server.stop! if !@server
end