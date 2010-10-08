module Tipping
  class Client
    attr_reader :host, :port, :timeout, :logger, :sock
    def initialize(options = {})
      @host = options[:host] || "127.0.0.1"
      @port = (options[:port] || 12345).to_i
      @timeout = (options[:timeout] || 5).to_i
      @logger = options[:logger]
      @sock = nil
    end

    def connect
      with_timeout(@timeout) do
        @sock = TCPSocket.new(host, port)
      end
    end

    def connected?
      !! @sock
    end

    def call(*args)
      process(args) do
        read
      end
    end

    def process(*args)
      
    end

    begin
      require "system_timer"

      def with_timeout(seconds, &block)
        SystemTimer.timeout_after(seconds, &block)
      end

    rescue LoadError
      warn "WARNING: using the built-in Timeout class which is known to have issues when used for opening connections. Install the SystemTimer gem if you want to make sure the Redis client will not hang." unless RUBY_VERSION >= "1.9" || RUBY_PLATFORM =~ /java/

      require "timeout"

      def with_timeout(seconds, &block)
        Timeout.timeout(seconds, &block)
      end
    end
  end
end
