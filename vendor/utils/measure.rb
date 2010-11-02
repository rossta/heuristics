module Utils
  module Measure
    def self.euclidean_distance(a, b)
      Math.sqrt(a.each_with_index.map { |val, i| (a[i] - b[i]) ** 2  }.inject(0) { |sum, val| sum += val })
    end
  end
end