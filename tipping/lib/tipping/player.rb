module Tipping

  class Player

    def self.play!
      new.play!
    end

    def play!
      server = TCPServer.open(2000)  # Socket to listen on port 2000
      loop {                         # Servers run forever
        client = server.accept       # Wait for a client to connect
        inputs = client.gets

        puts(Time.now.ctime)         # Send the time to the client
        puts "Reading..."
        inputs.split.each { |i| puts i }

        client.puts(Time.now.ctime)  # Send the time to the client
        client.puts "Bye!"
        client.close                 # Disconnect from the client
      }
    end

  end
end