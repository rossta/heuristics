module Utils

  module Timer

    def self.diff(t_1, t_2)
      ("%.3f" % (t_2 - t_1)).to_f
    end

    def time(msg = '', &block)
      t1 = Time.now
      puts msg
      yield
      t2 = Time.now
      diff = Timer.diff(t1, t2)
      puts " time #{diff}"
      puts ""
      diff
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
    

  end

end