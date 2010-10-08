module Tipping

  class Player
    
    MIN = :min
    MAX = :max
    
    def self.ready!
      new.listen
    end

    def listen
      game_over = false
      hostname = 'localhost'
      port = 2000

      request = "SET 1,3"
      while true
        socket    = TCPSocket.open(hostname, port)
        puts "Calculating..."
        sleep 1

        socket.write request
        response  = socket.recv(1024)

        case response.chop
        when "ACCEPT"
          puts "Thanks!"
          request = "SET 2,4"
        when "REJECT"
          puts "Retrying..."
          request = "SET 3,5"
        when "TIP"
          puts "OK... game over"
          socket.close  # Close the socket when done
          break
        else
          puts response.chop
        end
        sleep 1
      end
    end

  end
end