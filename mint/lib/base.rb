module Mint
  class Base

    attr_reader :results, :coin_set

    def initialize(multiplier)
      @multiplier = multiplier.to_i
      @coin_set   = [1,5,10,25,50]
      @results    = 1000000
    end

  end

  class ExactChange < Base

    def calculate_coin_set(*coin_set)
      cost    = Array.new(100, 0)
      results = 0
      (1..99).each do |i|
        cost[i]       = coin_set.map { |coin| cost[i - coin] + 1 if coin <= i }.compact.min
        current_cost  = i % 5 == 0 ? cost[i] * @multiplier : cost[i]
        results       = results + current_cost
        break if results > @results
      end
      results
    end

    def calculate!
      h = 1
      dollar = 100
      l_ceil  = dollar / 2
      l_floor = dollar / 4
      k_ceil  = dollar / 3
      k_floor = dollar / 5
      j_ceil  = dollar / 5
      j_floor = dollar / 12
      i_ceil  = dollar / 12
      i = h + 1
      j = j_floor
      k = k_floor
      l = l_floor
      while i <= i_ceil
        while j <= j_ceil
          while k <= k_ceil
            while l <= l_ceil
              results = calculate_coin_set(h, i, j, k, l)
              # puts coin_set_to_s([1, i, j, k, l])
              if @results > results
                @results = results
                @coin_set = [h, i, j, k, l]
                # puts "New coin set #{coin_set_to_s}"
              end
              l += 1
            end
            k += 1
            l = [k + 1, l_floor].max
          end
          j += 1
          k = [j + 1, k_floor].max
        end
        i += 1
        j = [i + 1, j_floor].max
      end
    end

  end
end