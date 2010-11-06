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

      @zones    = build_zones
    end

    def add_move(move)
      raise AddMoveError.new("Player #{move.player_id} not accounted for on board") if @moves[move.player_id].nil?
      @moves[move.player_id] << move
    end

    def score(player_id)
      all_moves = @moves.values.flatten
      return 0 if all_moves.empty?
      if all_moves.size == 1
        all_moves.first.player_id == player_id ? ZONING_DIMENSION ** 2 : 0
      end
      player_zones = zones.select { |zone| zone.closest_move(all_moves).player_id == player_id }
      player_zones.size
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

    protected

    def zone_score
      width, height = zone_dimensions
      width * height
    end

    def zone_dimensions
      @zone_dimensions ||= @size.map {|dim| dim / ZONING_DIMENSION }
    end

    def build_zones
      count = ZONING_DIMENSION
      width, height = zone_dimensions
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
  end
end