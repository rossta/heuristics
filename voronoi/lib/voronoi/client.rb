require 'socket'
module Voronoi
  class Client
    include Utils::Timer

    attr_reader :host, :port, :timeout, :sock

    def initialize(options = {})
      @host     = options[:host] || "localhost"
      @port     = (options[:port] || 44444).to_i
      @timeout  = (options[:timeout] || 5).to_i
      @sock     = nil
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
      response
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

    def echo(command)
      puts "Client >> #{command}"
    end

    def hear(command)
      puts "Server >> #{command}"
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

  end
end
