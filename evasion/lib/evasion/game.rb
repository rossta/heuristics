module Evasion
  class Game
    HUNTER  = "HUNTER"
    PREY    = "PREY"

    attr_accessor :hunter, :prey, :role, :width, :height,
      :wall_count, :wall_cooldown, :prey_cooldown, :turn, :walls

    def initialize(opts = {})
      @role   = opts[:role] || HUNTER

      @hunter = Hunter.new
      @prey   = Prey.new
    end

    def update_hunter(x, y, cooldown, direction)
      @hunter.update(x, y, cooldown, direction)
    end
    
    def update_prey(x, y, cooldown)
      @prey.update(x, y, cooldown)
    end
    
    def update_walls(*wall_data)
      @walls = wall_data.map { |d| Wall.new(*d) }
    end

  end

end