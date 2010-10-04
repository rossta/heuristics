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
      print "\n"

      print "Path           :"
      print "#{salesman.tour.cities.map(&:name).join("\t")}"
      print "\n"
      print "Edges traveled : #{salesman.tour.edges.size}"
      print "Cities visited : #{salesman.tour.cities.size}"
      print "Unique cities  : #{salesman.tour.cities.uniq.size}"
      print "\n"
      print "Total Distance : #{salesman.total_distance}"
      print "Running time   : #{("%.3f" % (t_2 - t_1)).to_f}"
      print "\n"
    end

    def print(text)
      puts text
    end
  end
end