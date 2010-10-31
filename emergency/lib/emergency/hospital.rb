module Emergency

  class Hospital
    include Positioning
    include ActsAsNamed

    attr_accessor :ambulances, :name

    def initialize(count)
      @ambulances = []
      count.times do |i|
        @ambulances << Ambulance.new(self)
      end
    end

    def reset_ambulances
      @ambulances.map(&:reset)
    end

    def cluster
      @cluster ||= []
    end
  end

end