module Evasion
  HUNTER  = :hunter
  PREY    = :prey
  MAX_INT = 1000000
  MIN_INT = -1000000
  N = "N"
  S = "S"
  E = "E"
  W = "W"
  NE = "NE"
  NW = "NW"
  SW = "SW"
  SE = "SE"
  DIRECTIONS = %w[ N S E W NW NE SE SW ]
  PASS = "PASS"
  ADD = "ADD"
  REMOVE = "REMOVE"

  class Game

    attr_accessor :hunter, :prey, :role, :width, :height, :outer,
      :wall_count, :wall_cooldown, :prey_cooldown, :turn, :walls

    def initialize(opts = {})
      @role   = opts[:role] || HUNTER

      @hunter = Hunter.new
      @prey   = Prey.new
      @wall_names = 0

      @walls  = []

      @width         = opts[:width] || 500
      @height        = opts[:height] || 500
      @wall_count    = opts[:wall_count] || 6
      @wall_cooldown = opts[:wall_cooldown] || 25
      @prey_cooldown = opts[:prey_cooldown] || 2

      @wall_count = 6
      @south = Wall.new(:south, 0, 0, width, 0)
      @east = Wall.new(:east, width, 0, width, height)
      @west = Wall.new(:west,   0, 0, 0, height)
      @north = Wall.new(:north,  0, height, width, height)
      @outer  = [
        @west,
        @north,
        @east,
        @south
      ]
    end

    def update_hunter(x, y, cooldown, direction)
      @hunter.update(x, y, cooldown, direction)
    end

    def update_prey(x, y, cooldown)
      @prey.update(x, y, cooldown)
    end

    def update_walls(*wall_data)
      @walls = wall_data.compact.map { |d| Wall.new(*d) }
    end

    def next_move
      # Hunter
      #
      # To do nothing and maintain ability ready state
      #
      # PASS
      # To add a new wall
      #
      # ADD _WALL_ID_ (x1, y1), (x2, y2)
      # where WALL_ID is any 1-4 digit integer you specify if you attempt to create a wall with an ID you've already used, creation will fail
      #
      # To remove a wall
      #
      # REMOVE _WALL_ID_
      # Note regarding walls: The action of adding or removing a wall occurs before the hunter makes its automatic move. Therefore the hunter may place a wall and instantly use it to bounce itself where the ID is an id you have already sent. If you remove a wall, you may reuse its ID
      #
      # Prey
      # To do nothing and maintain ability ready state
      #
      # PASS
      # To move you may either specify a vector
      #
      # N | S | E | W | NW | NE | SE | SW
      if role == PREY
        position = Position.new(@hunter.clone, @prey.clone)
        best_score, best_move = alpha_beta(position, 8)
        best_move
      else
        if should_add_wall?
          wall = best_wall
          @walls << wall
          "#{ADD} #{wall.to_coord}"
        else
          PASS
        end
      end
    end
    
    def should_add_wall?
      count = @walls.size
      third = @wall_count / 3
      if count < third
        available_moves(@hunter).include? ADD
      elsif count <= third * 2
        (@hunter.x > @prey.x) || (@hunter.y > @prey.y)
      else
        available_moves(@hunter).include? ADD
      end
    end

    def player_at_depth(depth)
      depth % 2 == 0 ? send(role) : send(:opponent)
    end

    def opponent
      @opponent ||= role == HUNTER ? @prey : @hunter
    end

    def alpha_beta(position, depth, alpha = MIN_INT, beta = MAX_INT)
      player = player_at_depth(depth)
      if depth == 0
        return [position.score(player), position.move]
      end

      available_moves = available_moves(player)

      return [position.score(player), position.move] if available_moves.empty?

      local_alpha = alpha
      best_value  = MIN_INT
      best_move   = available_moves.first

      available_moves.each do |move|
        position.do! move, player
        value, later_move = alpha_beta(position, depth - 1, -beta, -local_alpha)
        value = -value
        position.undo! move, player
        best_value  = [best_value, value].max
        best_move   = move if best_value == value
        break if (best_value > beta)
        local_alpha = best_value if best_value > local_alpha
      end

      # puts [best_value, best_move].join(", ")
      [best_value, best_move]
    end

    def available_moves(player)
      case player.name
      when HUNTER
        player.possible_moves - disallowed_wall_moves
      when PREY
        player.possible_moves - disallowed_prey_directions
      end
    end

    def best_wall
      name = next_wall_name
      max_x = [@prey.x, @hunter.x].max
      max_y = [@prey.y, @hunter.y].max

      h_walls = (all_walls - [@south]).select { |w| w.orientation == :horizontal }
      v_walls = (all_walls - [@west]).select { |w| w.orientation == :vertical }

      min_h = h_walls.map(&:y_1).min
      min_v = v_walls.map(&:x_1).min

      x = [max_x + 1, min_v - 1].min
      y = [max_y + 1, min_h - 1].min

      if h_walls.size > v_walls.size
        # make vert wall
        Wall.new(name.to_s, x, 1, x, min_h - 1)
      else
        # make horz wal
        Wall.new(name.to_s, 1, y, min_v - 1, y)
      end
    end

    def next_wall_name
      @wall_names += 1
      @wall_names.to_s
    end

    def disallowed_prey_directions
      clone = prey.clone
      clone.possible_moves.select do |dir|
        clone.direction = dir
        wall_contact?(clone.next_coord)
      end
    end

    def wall_contact?(coord)
      all_walls.any? { |w| w.intersects?(*coord) }
    end

    def all_walls
      @walls + @outer
    end

    def disallowed_wall_moves
      [].tap do |moves|
        if @walls.size >= @wall_count || @hunter.cooldown > 0
          moves << ADD
        end
        moves << REMOVE
      end
    end
  end

  class Position
    attr_accessor :prey, :hunter, :move
    def initialize(hunter, prey)
      @hunter = hunter
      @prey   = prey
      @move   = PASS
    end

    def score(player)
      dist_1 = distance @hunter.to_coord, @prey.to_coord
      dist_2 = distance @hunter.next_coord, @prey.next_coord
      diff   = dist_2 - dist_1
      case player.name
      when HUNTER
        -diff
      when PREY
        diff
      end
    end

    def distance(coord_1, coord_2)
      Utils::Measure.euclidean_distance(coord_1, coord_2)
    end

    def do!(move, player)
      @move = move
      case player.name
      when HUNTER

      when PREY
        @prey.move(move)
      end
    end

    def undo!(move, player)
      @move = PASS
      case player.name
      when HUNTER
        return
      when PREY
        @prey.move_back(move)
      end
    end


  end
end

