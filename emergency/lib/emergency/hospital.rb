module Emergency

  class Hospital
    attr_accessor :ambulances

    def initialize(count)
      @ambulances = []
      count.times do |i|
        @ambulances << Ambulance.new
      end
    end
  end

  class Ambulance
  end
end