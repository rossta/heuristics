module Evasion
  class Game
    HUNTER  = "HUNTER"
    PREY    = "PREY"

    attr_accessor :hunter, :prey, :role, :width, :height, :wall_count, :wall_cooldown, :prey_cooldown

    def initialize(opts = {})
      @role   = opts[:role]

      @hunter = Hunter.new
      @prey   = Prey.new
    end
  end

end