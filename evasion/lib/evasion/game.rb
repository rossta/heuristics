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
        position = Position.new(@hunter.clone, @prey.clone, all_walls)
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
      if count < 2
        available_moves(@hunter).include?(ADD)        
      elsif count < 4
        available_moves(@hunter).include?(ADD) && ((@hunter.x >= @prey.x - 5) || (@hunter.y >= @prey.y - 5))
      elsif count < 5
        available_moves(@hunter).include?(ADD) && ((@hunter.x <= @prey.x - 5) && (@hunter.y <= @prey.y - 5))
      else
        available_moves(@hunter).include?(ADD)
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
      min_x = [@prey.x, @hunter.x].min
      max_y = [@prey.y, @hunter.y].max
      min_y = [@prey.y, @hunter.y].min

      h_walls = all_walls.select { |w| w.orientation == :horizontal }
      v_walls = all_walls.select { |w| w.orientation == :vertical }

      n_wall = h_walls.select { |w| w.y_1 > max_y }.map(&:y_1).min
      e_wall = v_walls.select { |w| w.x_1 > max_x }.map(&:x_1).min
      s_wall = h_walls.select { |w| w.y_1 <= min_y }.map(&:y_1).max
      w_wall = v_walls.select { |w| w.x_1 <= min_x }.map(&:x_1).max

      e_dx = e_wall - max_x
      w_dx = min_x - w_wall
      n_dx = n_wall - max_y
      s_dx = min_y - s_wall

      if h_walls.size > v_walls.size
        # make vert wall
        if e_dx > w_dx
          # make east wall
          Wall.new name.to_s, max_x + 1, s_wall + 1, max_x + 1, n_wall - 1
        else
          Wall.new name.to_s, min_x - 1, s_wall + 1, min_x - 1, n_wall - 1
          # make west wall
        end
      else
        # make horz wall
        if n_dx > s_dx
          # make north wall
          Wall.new name.to_s, w_wall + 1, max_y + 1, e_wall - 1, max_y + 1
        else
          # make south wall
          Wall.new name.to_s, w_wall + 1, min_y - 1, e_wall - 1, min_y - 1
        end
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
    def initialize(hunter, prey, walls)
      @hunter = hunter
      @prey   = prey
      @walls  = walls
      @move   = PASS
    end

    def max_x
      [@hunter.x, @prey.x].max
    end

    def max_y
      [@hunter.y, @prey.y].max
    end

    def min_x
      [@hunter.x, @prey.x].min
    end

    def min_y
      [@hunter.y, @prey.y].min
    end

    def h_walls
      @h_walls ||= @walls.select { |w| w.orientation == :horizontal }
    end

    def v_walls
      @v_walls ||= @walls.select { |w| w.orientation == :vertical }
    end

    def n_wall
      h_walls.select { |w| w.y_1 > max_y }.map(&:y_1).min
    end

    def s_wall
      h_walls.select { |w| w.y_1 <= min_y }.map(&:y_1).max
    end

    def e_wall
      v_walls.select { |w| w.x_1 > max_x }.map(&:x_1).min
    end

    def w_wall
      v_walls.select { |w| w.x_1 <= min_x }.map(&:x_1).max
    end

    def wall_dx
      dist_1 = [(e_wall - @prey.to_coord[0]).abs, (w_wall - @prey.to_coord[0]).abs].min
      dist_2 = [(e_wall - @prey.next_coord[0]).abs, (w_wall - @prey.next_coord[0]).abs].min
      dist_2 - dist_1
    end

    def wall_dy
      dist_1 = [(n_wall - @prey.to_coord[1]).abs, (s_wall - @prey.to_coord[1]).abs].min
      dist_2 = [(n_wall - @prey.next_coord[1]).abs, (s_wall - @prey.next_coord[1]).abs].min
      dist_2 - dist_1
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

