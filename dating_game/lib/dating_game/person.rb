module DatingGame
  class Person
    attr_accessor :path
    def generate_person_file(count)
      @count = count.to_i
      file = File.open(File.join(@path), "w+")

      up = @count / 2
      dn = @count - up
      weights = up_weights(up) + down_weights(dn)
      while !weights.empty?
        index   = rand(weights.size)
        weight  = weights.delete_at(index)
        file.puts weight
      end
      file.close

      File.join(@path)
    end

    def up_weights(count)
      ups = [].tap { |arr| count.times { arr << rand(100) } }
      sum = ups.inject(&:+)
      while (sum != 100)
        index = rand(ups.size)
        val = ups[index]
        if sum > 100
          val = val - 1
          ups[index] = val if val > 1 && !ups.include?(val)
        else
          val = val + 1
          ups[index] = val if val < 100 && !ups.include?(val)
        end
        sum = ups.inject(&:+)
      end
      ups.map { |v| v.to_f / 100 }
    end

    def down_weights(count)
      downs = [].tap { |arr| count.times { arr << -rand(100) } }
      sum = downs.inject(&:+)
      while (sum != -100)
        index = rand(downs.size)
        val = downs[index]
        if sum > -100
          val = val - 1
          downs[index] = val if val > -100 && !downs.include?(val)
        else
          val = val + 1
          downs[index] = val if val < 1 && !downs.include?(val)
        end
        sum = downs.inject(&:+)
      end
      downs.map { |v| v.to_f / 100 }
    end

  end
end