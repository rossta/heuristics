module Mint
  class Base

    def initialize(opts)
      @five_cent_multiplier         = opts.multiplier
      @coin_set = [1,5,10,25,50]
    end

    def run!
      puts "running..."
      @results = exact_change_number(1, 5, 10, 25, 50)
    end

    def exact_change_number(*coin_set)
      m = min_change_matrix = (0..99).to_a
      total_exact_change_number = 0
      (1..99).to_a.each do |i|
        min = 100000
        5.times do |j|
          if coin_set[j] <= i && (min > m[i - coin_set[j]] + 1)
            min = m[i - coin_set[j]] + 1
          end
        end
        m[i] = min
        if i % 5 == 0
          total_exact_change_number = total_exact_change_number + (m[i] * @five_cent_multiplier)
        else
          total_exact_change_number = total_exact_change_number + m[i]
        end
      end
      [total_exact_change_number, vector_average(m)]
    end
    
    def vector_average(m)
      m.inject(0) {|sum, element| sum+element} / m.length
    end
    
    def total_exact_change_number
      @results[0]
    end
    
    def average_exact_change_number
      @results[1]
    end

  end
end