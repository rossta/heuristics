module Emergency

  class Person
    include Positioning
    include ActsAsNamed

    def self.reset_all
      all.map { |p| p.reset }
    end

    def self.saved
      all.select {|p| p.saved? }
    end

    def self.max_time
      @@max_time
    end

    def self.max_time=(max_time)
      @@max_time = max_time
    end

    attr_accessor :time, :name, :save_count

    def initialize(x, y, time)
      @position = Position.new(x, y)
      @time = time
      @saved = false
    end

    def alive?(expired_time)
      time_left(expired_time) >= 0
    end

    def time_left(expired_time)
      time - expired_time
    end

    def hospital_distance
      @hospital_distance ||= nearest_hospital.distance_to(position)
    end

    def drop_at(hospital)
      @saved = true
      @dropped = true
      @hospital_distance = 0
    end

    def reset
      @saved = false
      @dropped = false
      @hospital_distance = nil
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