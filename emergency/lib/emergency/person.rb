module Emergency

  class Person
    include Positioning
    include ActsAsNamed
    
    PHEROME_CONSTANT = 0.009
    
    def self.reset_all
      all.map { |p| p.reset }
    end

    def self.saved
      all.select {|p| p.saved? }
    end

    attr_accessor :time, :name, :save_count
    attr_reader :pherome

    def initialize(x, y, time)
      @position = Position.new(x, y)
      @original_position = @position
      @time = time
      @saved = false
      @pherome = 0
    end

    def alive?(expired_time)
      time_left(expired_time) >= 0
    end

    def time_left(expired_time)
      time - expired_time
    end

    def hospital_distance
      @hospital_distance ||= nearest(Hospital.all).distance_to(position)
    end

    def drop_at(hospital)
      @saved = true
      @dropped = true
      @pherome += 1
      @position = hospital.position
      @hospital_distance = 0
    end

    def reset
      @saved = false
      @dropped = false
      @position = @original_position
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

    def update_pherome(score)
      @pherome = ((1 - (1/score)) * @pherome)
    end
    
  end
end