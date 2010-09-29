module Salesman

  class Runner
    attr_accessor :path

    def self.run!(path)
      runner = new(path)
      runner.run!
    end

    def initialize(path)
      @path = path
    end

    def run!
      t_1     = Time.now
      print "Calculating for cities #{path} ...\n"
      salesman = Salesman::Base.new(path)
      salesman.calculate!
      t_2     = Time.now
      print "Running time : #{("%.3f" % (t_2 - t_1)).to_f}"
      print "\n"
    end

    def print(text)
      puts text
    end
  end
end