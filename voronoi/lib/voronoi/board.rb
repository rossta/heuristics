module Voronoi
  class AddMoveError < RuntimeError; end

  class Board
    ZONE_DIMENSION = 10
    ZONING_DIMENSION = 100
    SIZE = [400, 400]

    attr_reader :size, :moves, :zones, :players
    def initialize(opts = {})
      @size     = opts[:size]     || SIZE
      @players  = opts[:players]  || 2
      @moves    = {}
      @players.times { |i| @moves[i+1] = [] }
    end

    def add_move(move)
      raise AddMoveError.new("Player #{move.player_id} not accounted for on board") if @moves[move.player_id].nil?
      @moves[move.player_id] << move
      move
    end

    def score(player_id, opts = {})
      moves     = opts[:moves] || all_moves
      zones     = opts[:zones] || build_zones(ZONING_DIMENSION)
      return 0 if moves.empty?
      if moves.size == 1
        moves.first.player_id == player_id ? 1.0 : 0.0
      end
      player_zones = zones.select { |zone| zone.closest_move(moves).player_id == player_id }
      player_zones.size.to_f / zones.size.to_f
    end

    def all_moves
      @moves.values.flatten
    end
    
    def moves_by(player_id)
      @moves[player_id]
    end

    class Zone
      attr_reader :x, :y, :width, :height

      def initialize(x, y, width, height)
        @x = x; @y = y; @width = width; @height = height
      end

      def center
        @center ||= [@x + (@width / 2), @y + (@height / 2)]
      end

      def closest_move(moves)
        moves.min { |a, b|
          dist_a = distance_to(a.to_coord)
          dist_b = distance_to(b.to_coord)
          if dist_a != dist_b
            dist_a <=> dist_b
          else
            (rand(2) == 1 ? 1 : -1) <=> 0
          end
        }
      end

      def distance_to(coord)
        Utils::Measure.euclidean_distance(center, coord)
      end
    end

    def build_zones(count = ZONING_DIMENSION)
      width, height = zone_dimensions(count)
      [].tap do |zones|
        x = 0
        y = 0
        count.times do |i|
          count.times do |j|
            zones << Zone.new(x, y, width, height)
            x += width
          end
          x = 0
          y += height
        end
      end
    end

    protected

    def zone_dimensions(dim = ZONING_DIMENSION)
      @size.map {|side| side / dim }
    end

  end
end