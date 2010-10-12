module Tipping

  class Server

    def initialize(port)
      begin
        @server = TCPServer.new('localhost', port)
      rescue Exception => e
        puts e.message
      end

      # 2.times do
      # establishes client connection. Waits till a client connects
        # Thread.start(@server.accept) do |client|
        client = @server.accept
        handle(client)
        # end
      # end
    end
    
    def handle(client)
      begin
        input = client.readline

        if (input.nil?)
          puts "Error:No request received"
          return false
        elsif (input.chop.length == 0)
          puts "Error:Zero length request"
          return false
        end

        tag = input.chop
        client.puts "Connected accepted for #{tag}"
        puts        "Connected with client #{tag}"
        sleep 1
        client.flush
        connection = Controller.new(tag)

        while input = client.readline
          next if input.chomp.empty?

          if input =~ /bye/i
            puts "Client #{tag} terminated connection"
            client.puts "Bye"
            break
          end

          response = connection.process(input)
          puts "#{tag}: #{input}"
          puts response
          client.puts response
        end

        client.close
      rescue Exception => e
        puts "Error while attempting to connect to port #{port}"
        puts e.message
      end
    end
  end

  class Client

    def initialize(tag, port)
      @tag = tag
      TCPSocket.open('localhost', port) do |server|
      server.puts ARGV[0]
      server.flush
      sleep 1
      puts server.gets.chomp

        # STDOUT.print server.readline
      loop do
        input = STDIN.gets
        server.puts input
        server.flush
        puts server.gets.chomp

        break if input.chomp =~ /bye/i
      end

      end
    end

  end

  class Controller
    def initialize(tag)
      @weights = {}

      10.times { |i| w = "#{i+1}"; @weights[w] = w }
      @tag = tag
    end

    def process(request)
      weight, placement = request.split(',')
      if @weights.key?(weight)
        if @weights[weight] == weight
          @weights[weight] = nil
          return "ACCEPT"
        else
          return "REJECT [Weight Aready used]"
        end
      else
        return "REJECT [Invalid Weight]"
      end
    end

    def weights_used
      @weights.values.collect { |v| !v }
    end
  end

end

  #           while ((inputline = in.readLine()) != null) {
  #
  #   if (inputline.trim().equals(""))
  #     continue;
  #
  #   System.out.println(getTag() + ": " + inputline);
  #   if (inputline.equals("Bye")) {
  #     System.out.println("Client " + getTag() + " terminated connection");
  #     out.println("Bye");
  #     break;
  #   }
  #
  #   String[] res = inputline.split(",");
  #   if (weights.containsKey(res[0])) {
  #     if (weights.get(res[0])) {
  #       weights.put(res[0], false);
  #       weights_used++;
  #       out.println("ACCEPT");
  #     } else {
  #       out.println("REJECT [Weight Aready used]");
  #     }
  #
  #   } else {
  #     out.println("REJECT [Invalid Weight]");
  #   }
  #
  #   inputline = "";
  #   //out.println(inputline);
  #
  # }

# puts "keep alive is " + client.keep_alive

#     clientSocket.setKeepAlive(true);
#     clientSocket.setTcpNoDelay(true);

# Thread.start(client) do |c|
  # connection = Tipping::Connection.new(client)
  # print("Client is accepted\n")
  # connection.run
  # client.write(Time.now)
  # print("Client is gone\n")
  # client.close
# end
# loop do
#   input = client.recv(1024)
#   puts "Client: #{input.chomp}"
#
#   client.write("ACCEPT")
#   client.flush
# end
