module Mint
  class Base
    attr_reader :total_exact_change_number, :average_exact_change_number

    def initialize(opts)
      @five_cent_multiplier         = opts.multiplier
      @total_exact_change_number    = 0
      @average_exact_change_number  = 0
    end

    def run!
      99.times do |i|
        min = 100000
        5.times do |j|
          
        end
      end
    end

    def min_change_matrix
      @min_change_matrix ||= []
    end

  end
end