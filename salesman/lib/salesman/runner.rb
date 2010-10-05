module Salesman

  class Runner
    include Utils::Timer

    attr_accessor :path

    def self.run!(path)
      runner = new(path)
      runner.run!
    end

    def initialize(path)
      @path = path
    end

    def run!
      salesman = Salesman::Base.new(path)

      time_diff = time "Calculating for cities #{path} ..." do
        salesman.calculate!
      end

      print "Path           :"
      print "#{salesman.tour.cities.map(&:name).join("\t")}"
      print "\n"
      print "Edges traveled : #{salesman.tour.edges.size}"
      print "Cities visited : #{salesman.tour.cities.size - 1}"
      print "Unique cities  : #{salesman.tour.cities.uniq.size}"
      print "\n"
      print "Total Distance : #{salesman.total_distance}"
      print "Running time   : #{time_diff}"
      print "\n"
    end

    def print(text)
      puts text
    end
  end
end