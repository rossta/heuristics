module Mint
  class Base

    attr_reader :time

    def initialize(multiplier)
      @multiplier = multiplier.to_i
      @coin_set   = [1,5,10,25,50]
      @results    = 1000000
    end

    def run!
      @results  = exact_change_number(*@coin_set)
      run_incremental_division_in_range_strategy
    end

    def exact_change_number(*coin_set)
      m = min_change_matrix = Array.new(100, 0)
      total_exact_change_number = 0
      (1..99).each do |i|
        m[i] = coin_set.map { |coin| m[i - coin] + 1 if coin <= i }.compact.min
        cost = i % 5 == 0 ? m[i] * @multiplier : m[i]
        total_exact_change_number = total_exact_change_number + cost
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

    def run_range_strategy
      h = 1
      dollar = 100
      half_dollar = dollar / 2
      i = h + 1
      j = h + 2
      k = h + 3
      l = h + 4
      while i <= (dollar / 8) - h
        while j <= (dollar / 4) - i
          while k <= (dollar / 2) - j
            while l < dollar - k
              results = exact_change_number(1, i, j, k, l)
              # puts coin_set_to_s([1, i, j, k, l])
              if @results > results
                @results = results
                @coin_set = [1, i, j, k, l]
                # puts "New coin set #{coin_set_to_s}"
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
    end

    def run_halving_strategy
      h = 1
      dollar = 100
      half_dollar = dollar / 2
      i = h + 1
      j = h + 2
      k = h + 3
      l = h + 4
      while i <= (dollar / 8) - h
        while j <= (dollar / 4) - i
          while k <= (dollar / 2) - j
            while l < dollar - k
              results = exact_change_number(1, i, j, k, l)
              # puts coin_set_to_s([1, i, j, k, l])
              if @results > results
                @results = results
                @coin_set = [1, i, j, k, l]
                # puts "New coin set #{coin_set_to_s}"
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
    end

    def run_incremental_division_strategy
      h = 1
      dollar = 100
      half_dollar = dollar / 2
      i = h + 1
      j = h + 2
      k = h + 3
      l = h + 4
      while i <= (dollar / 5)
        while j <= (dollar / 4)
          while k <= (dollar / 3)
            while l <= (dollar / 2)
              results = exact_change_number(1, i, j, k, l)
              # puts coin_set_to_s([1, i, j, k, l])
              if @results > results
                @results = results
                @coin_set = [1, i, j, k, l]
                # puts "New coin set #{coin_set_to_s}"
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
    end

    def run_incremental_division_in_range_strategy
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
              results = exact_change_number(h, i, j, k, l)
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