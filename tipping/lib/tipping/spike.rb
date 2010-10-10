module Tipping

  class Player

    ONE = :one
    TWO = :two

    def initialize(turn = ONE)
      @turn = turn
    end

    def choose_move
      best_move = alpha_beta_move
    end

    def move
      # choose_best_move
      #   iterative_deepening
      #   best_value = alphabetamove
      # send_move_request
      #   handle_error
    end

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