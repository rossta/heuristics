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

  end

end