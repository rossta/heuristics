module Emergency

  class Person
    include Positioning
    include ActsAsNamed

    attr_accessor :time, :name

    def initialize(x, y, time)
      @position = Position.new(x, y)
      @time = time
    end

  end
end