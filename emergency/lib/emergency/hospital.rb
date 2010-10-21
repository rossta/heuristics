module Emergency

  class Hospital
    include Positioning
    include ActsAsNamed

    attr_accessor :ambulances, :name

    def initialize(count)
      @ambulances = []
      count.times do |i|
        @ambulances << Ambulance.new
      end
    end

    def assign_ambulance_positions
      @ambulances.each do |a|
        a.position = position
      end
    end

  end

  class Ambulance
    include Positioning
    include ActsAsNamed

    def initialize
      @time = 0
    end

  end

end