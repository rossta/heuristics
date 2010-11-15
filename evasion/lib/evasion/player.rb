module Evasion
  class Player

    attr_accessor :x, :y, :cooldown, :direction

    def update(x, y, cooldown)
      @x = x
      @y = y
      @cooldown = cooldown
    end

    def to_coord
      [x, y]
    end
    
    def move(dir)
      @direction = dir
      dx, dy = delta
      @x += dx
      @y += dy
    end
    
    def move_back(dir)
      @direction = opposite(dir)
      dx, dy = delta
      @x += dx
      @y += dy
    end

    def next_coord
      dx, dy = delta
      [x + dx, y + dy]
    end
    
    def delta
      dx = case direction
      when /PASS/
        0
      when /E/
        advance
      when /W/
        -advance
      else
        0
      end

      dy = case direction
      when /PASS/
        0
      when /N/
        advance
      when /S/
        -advance
      else
        0
      end
      [dx, dy]
    end
    
    def opposite(dir)
      case dir
      when N
        S
      when S
        N
      when E
        W
      when W
        E
      when NE
        SW
      when SW
        NE
      when SE
        NW
      when NW
        SE
      else
        PASS
      end
    end
  end

  class Hunter < Player
    def initialize
      update(0, 0, 0, "NE")
    end

    WALL_MOVES = %w[ ADD REMOVE ]
    def update(x, y, cooldown, direction)
      super(x, y, cooldown)
      @direction = direction
    end

    def name
      HUNTER
    end

    def advance
      2
    end

    def possible_moves
      WALL_MOVES + [PASS]
    end
  end

  class Prey < Player
    def initialize
      update(330, 200, 0)
    end

    def name
      PREY
    end

    def advance
      1
    end

    def possible_moves
      if cooldown > 0
        [PASS]
      else
        DIRECTIONS
      end
    end
  end
end