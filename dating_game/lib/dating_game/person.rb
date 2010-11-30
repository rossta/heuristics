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
      i = 1
      ups = [].tap { |arr| 
        count.times { arr << i; i += 0.5 } 
      }
      sum = ups.inject(&:+)
      puts " UPS___________________________________________ "
      while (sum != 100)
        puts sum
        puts ups.join " "
        index = ups.size-1
        val = ups[index]
        if sum > 100
          val = val - 0.5
          ups[index] = val if val > 1 && !ups.include?(val)
        else
          val = val + 0.5
          ups[index] = val if val < 100 && !ups.include?(val)
        end
        sum = ups.inject(&:+)
      end
      ups.map { |v| v.to_f / 100 }
    end

    def down_weights(count)
      i = -1
      downs = [].tap { |arr| 
        count.times { arr << i; i -= 0.5 } 
      }
      sum = downs.inject(&:+)
      puts " DOWNS___________________________________________ "
      while (sum != -100)
        puts downs.join " "
        index = rand(downs.size)
        val = downs[index]
        if sum > -100
          val = val - 0.5
          downs[index] = val if val > -100 && !downs.include?(val)
        else
          val = val + 0.5
          downs[index] = val if val < 1 && !downs.include?(val)
        end
        sum = downs.inject(&:+)
      end
      downs.map { |v| v.to_f / 100 }
    end

  end
end