module Mint
  class Base

    attr_reader :results, :coin_set

    def initialize(multiplier)
      @multiplier = multiplier.to_i
      @coin_set   = [1,5,10,25,50]
      @results    = 99999999
    end

    def max_integer
      @max_integer ||=
      machine_bytes = ['foo'].pack('p').size
      machine_bits = machine_bytes * 8
      machine_max_signed = 2**(machine_bits-1) - 1
      machine_max_unsigned = 2**machine_bits - 1
    end

  end

  class Exchange < Base

    MAX_EXCHANGE = 200

    def calculate_coin_set(*coin_set)
      dollar  = 100
      cost    = Array.new(100, 0)
      results = 0
      coin_set << dollar
      (1..99).each do |i|
        cost[i]       = coin_set.map { |coin|
          cost[i - coin] + 1 if coin <= i
        }.compact.min
      end
      (1..99).each do |i|
        cost[i]       = coin_set.map { |coin|
          if coin == dollar
            cost[coin - i]
          elsif coin >= i
            cost[coin - i] + 1
          end
        }.compact.min
        break if cost[i] > MAX_EXCHANGE
        current_cost  = i % 5 == 0 ? cost[i] * @multiplier : cost[i]
        results       = results + current_cost
        break if results > @results
      end

      results
    end

    def calculate!
      h = 1
      dollar = 100
      h_ceil  = 2
      i_ceil  = dollar / 6
      j_ceil  = dollar / 2 - 8
      k_ceil  = dollar / 2 - 4
      l_ceil  = dollar / 2
      i       = h + 1
      j_floor = j = 20
      k_floor = k = 30
      l_floor = l = 40
      while h < h_ceil
        while i <= i_ceil
          while j <= j_ceil
            while k <= k_ceil
              while l <= l_ceil
                results = calculate_coin_set(h, i, j, k, l)
                if @results > results
                  @results = results
                  @coin_set = [h, i, j, k, l]
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
        h += 1
        i = h + 1
      end
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
              if @results > results
                @results = results
                @coin_set = [h, i, j, k, l]
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

    def calculate_naively!
      h = 1
      dollar = 100
      half_dollar = dollar / 2
      i = h + 1
      j = h + 2
      k = h + 3
      l = h + 4
      while i <= dollar / 8
        while j <= dollar / 4
          while k <= dollar / 2
            while l < dollar
              results = calculate_coin_set(h, i, j, k, l)
              if @results > results
                @results = results
                @coin_set = [h, i, j, k, l]
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
  end

end