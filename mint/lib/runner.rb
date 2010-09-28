module Mint

  class Runner
    attr_accessor :algorithm, :n, :file

    def self.run!(algorithm, n, file = nil)
      runner = new(algorithm, n, file)
      runner.run!
    end

    def initialize(algorithm, n, file)
      @algorithm = algorithm
      @n = n
      @file = file
    end

    def run!
      t_1     = Time.now
      mint    = case @algorithm
      when :exact_change
        Mint::ExactChange.new(n)
      when :exchange
        Mint::Exchange.new(n)
      else
        raise "unknown algorithm referenced: #{@algorithm.to_s}"
      end
      print "Calculating for N = #{n} ...\n"
      mint.calculate!
      t_2     = Time.now
      print "Total #{@algorithm.to_s.gsub(/_/, " ")} number    : #{mint.results}"
      print "Coin set                     : #{mint.coin_set.join(", ")}"
      print "Running time                 : #{("%.3f" % (t_2 - t_1)).to_f}"
      print "\n"
    end

    def print(text)
      if file.respond_to?("puts")
        file.puts text
      else
        puts text
      end
    end
  end
end