module Mint
  class Base

    def initialize(opts)
      @five_cent_multiplier         = opts.multiplier.to_i
      @coin_set = [1,5,10,25,50]
      @results = 1000000
    end

    def run!
      puts "Beginning coin set #{coin_set_to_s}"
      @results = exact_change_number(*@coin_set)
      h = 1
      dollar = 100
      half_dollar = dollar / 2
      i = h + 1
      j = h + 2
      k = h + 3
      l = h + 4
      while i <= half_dollar - 3
        while j <= half_dollar - 2
          while k <= half_dollar - 1
            while l <= half_dollar
              results = exact_change_number(1, i, j, k, l)
              if @results > results
                @results = results
                @coin_set = [1, i, j, k, l]
                puts "New coin set #{coin_set_to_s}"
              end
              l += 1
            end
            k += 1
            l = k + 1
          end
          j += 1
          k = j + 1
        end
        i += 1
        j = i + 1
      end
      @results = exact_change_number(*@coin_set)
    end

    def exact_change_number(*coin_set)
      m = min_change_matrix = Array.new(100, 0)
      total_exact_change_number = 0
      (1..99).each do |i|
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
        break if total_exact_change_number > @results
      end
      total_exact_change_number
    end

    def total_exact_change_number
      @results
    end

    def coin_set_to_s(coin_set = @coin_set)
      coin_set.join(", ")
    end
  end
end