module Emergency

  class Clock
    @@time = 0

    def self.tick(time = 1)
      @@time += time
    end

    def self.time
      @@time
    end

    def self.reset
      @@time = 0
    end

  end
end