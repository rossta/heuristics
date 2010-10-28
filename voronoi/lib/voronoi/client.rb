module Voronoi
  class Client
    attr_reader :host, :port, :timeout, :sock, :name

    def initialize(options = {})
      @host = options[:host] || "localhost"
      @port = (options[:port] || 4445).to_i
      @timeout = (options[:timeout] || 5).to_i
      @name = options[:name] || "Client"
      @sock = nil
    end

    def connect
      with_timeout(@timeout) do
        @sock = TCPSocket.new(host, port)
      end
    end

    def disconnect
      # untested
      return unless connected?

      begin
        @sock.close
      rescue
      ensure
        @sock = nil
      end
    end

    def reconnect
      # untested
      disconnect
      connect
    end

    def connected?
      !! @sock
    end

    def call(command)
      process(command)
    end

    def read
      begin
        response = @sock.gets.chomp
      rescue Errno::EAGAIN
        disconnect
        raise Errno::EAGAIN, "Timeout reading from the socket"
      end
      raise Errno::ECONNRESET, "Connection lost" unless response

      hear response
      interpret response
    end

    def process(command)
      logging(command) do
        ensure_connected do
          @sock.puts(command)
          @sock.flush
          yield if block_given?
        end
      end
    end

    begin
      require "system_timer"

      def with_timeout(seconds, &block)
        SystemTimer.timeout_after(seconds, &block)
      end

    rescue LoadError
      warn "WARNING: using the built-in Timeout class" unless RUBY_VERSION >= "1.9" || RUBY_PLATFORM =~ /java/

      require "timeout"

      def with_timeout(seconds, &block)
        Timeout.timeout(seconds, &block)
      end
    end

    def echo(command)
      puts "#{@name} >> #{command}"
    end

    def hear(command)
      puts "Game >> #{command}"
    end

    protected

    def ensure_connected
      connect unless connected?

      begin
        yield
      rescue Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNABORTED
        if reconnect
          yield
        else
          raise Errno::ECONNRESET
        end
      end
    end

    def logging(command)
      begin
        echo command

        # t1 = Time.now
        yield
      ensure
        # echo "%0.2fms" % ((Time.now - t1) * 1000)
      end
    end

    def interpret(line)
      response = line.split("|")
      case response.first
      when /^ADD/, /^REMOVE/
        format_add_remove(line)
      when /^WIN/
        echo "FTW!"
        disconnect
        response
      when /^TIP/, /^LOSE/
        echo "Waa Waa. I lose."
        disconnect
        response
      when /^ACCEPT/, /^REJECT/
        response
      when /^TIMEOUT/
        reconnect
      else
        response
      end
    end

    def format_add_remove(line)
      command, position_str, torque_str = line.split("|")
      positions = {}
      torques = {}
      position_str.split(" ").each { |move|
        wt, loc = move.split(",")
        positions[loc.to_i] = wt.to_i
      }
      in_eq, out_eq = torque_str.split(",")
      torques[:right] = in_eq.split("=").last.to_f
      torques[:left] = out_eq.split("=").last.to_f
      [command, positions, torques]
    end
  end
end
