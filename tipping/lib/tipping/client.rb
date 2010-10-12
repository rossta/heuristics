module Tipping
  class Client
    attr_reader :host, :port, :timeout, :logger, :sock

    def initialize(options = {})
      @host = options[:host] || "localhost"
      @port = (options[:port] || 12345).to_i
      @timeout = (options[:timeout] || 5).to_i
      @logger = options[:logger] || logger(:DEBUG)
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

    def call(*args)
      process(args) do
        read
      end
    end

    def process(*args)
      logging(commands) do
        ensure_connected do
          @sock.write(join_commands(commands))
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

    def logging(commands)
      return yield unless @logger && @logger.debug?

      begin
        commands.each do |name, *args|
          @logger.debug("Redis >> #{name.to_s.upcase} #{args.join(" ")}")
        end

        t1 = Time.now
        yield
      ensure
        @logger.debug("Redis >> %0.2fms" % ((Time.now - t1) * 1000))
      end
    end

    def logger(level, namespace = nil)
      logger = (namespace || Kernel).const_get(:Logger).new("/dev/null")
      logger.level = (namespace || Logger).const_get(level)
      logger
    end

  end
end
