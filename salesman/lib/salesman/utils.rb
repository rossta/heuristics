module Salesman
  
  class Measure
    def self.distance(a, b)
      Math.sqrt(a.each_with_index.map { |val, i| (a[i] - b[i]) ** 2  }.inject(0) { |sum, val| sum += val })
    end

    def self.score(a, b)
      a.each_with_index.map { |val, i| (a[i] - b[i]).abs  }.inject(0) { |sum, val| sum += val }
    end
  end
  
end