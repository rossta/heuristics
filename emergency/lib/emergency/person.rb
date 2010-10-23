module Emergency

  class Person
    include Positioning
    include ActsAsNamed

    def self.all
      @@all
    end

    def self.all=(all)
      @@all = all
    end

    def self.saved
      all.select {|p| p.saved? }
    end

    attr_accessor :time, :name

    def initialize(x, y, time)
      @position = Position.new(x, y)
      @time = time
      @saved = false
    end

    def alive?
      time_left > 0
    end

    def time_left
      time - Clock.time
    end

    def hospital_distance
      @hospital_distance ||= nearest(Hospital.all).distance_to(position)
    end

    def drop_at(hospital)
      @saved = true if alive?
      @dropped = true
      self.position = hospital.position
      @hospital_distance = 0
    end

    def unsave!
      @saved = false
    end

    def saved?
      @saved
    end

    def dropped?
      @dropped
    end

    def description
      to_coord + [time]
    end

    def display_name
      "#{name} (#{description.join(',')})"
    end

  end
end