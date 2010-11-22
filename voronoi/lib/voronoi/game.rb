module Voronoi

  class Game
    include Utils::Timer

    MAX_SCORE = 1.0
    GREEDY_MIN = 0.9
    BEST_GREEDY_MIN = 0.9
    DEFENSE_MIN = 0.5
    BEST_DEFENSE_MIN = 0.51
    DEFENSE_MAX = 0.6
    TOTAL_TIME_LIMIT = 120

    attr_reader :board, :size, :move_count, :players
    attr_accessor :player_id
    def initialize(size, move_count, players, player_id)
      @size       = size
      @move_count = move_count
      @players    = players
      @player_id  = player_id
      @board      = Board.new({
                      :size => [size,size],
                      :players => @players
                    })
    end

    def record_move(x, y, player_id)
      move = Move.new(x, y, player_id)
      @board.add_move(move)
      move
    end

    def num_moves
      @board.all_moves.size
    end

    def player_moves
      @board.moves_by(player_id)
    end

    def find_and_record_next_move
      all_moves = @board.all_moves
      all_zones = @board.build_zones(zone_dimension)
      all_moves.map(&:reset_zones!)
      @board.score(@player_id, {
        :moves => all_moves,
        :zones => all_zones
      })
      opp_moves = all_moves.select { |m| m.player_id != @player_id }
      best_move = Move.worst_move(@player_id)
      moves = [].tap do |saved_moves|
        begin
          iter = 0
          base_x = @size / 2
          base_y = @size / 2
          with_timeout time_limit do
            if opp_moves.any?
              opp_move  = opp_moves.sort { |m_1,m_2| m_2.zones.size <=> m_1.zones.size }.first || Move.new(@size/2, @size/2, nil)
              zones     = opp_move.zones
              zones.sort! { |a,b| a.distance_to(opp_move.to_coord) <=> b.distance_to(opp_move.to_coord) }
              closest_zone  = zones.first
              farthest_zone = zones.last
              if greedy_move?
                base_x = closest_zone.x
                base_y = closest_zone.y
              else
                base_x = ((closest_zone.x - farthest_zone.x) / 2) + farthest_zone.x
                base_y = ((closest_zone.y - farthest_zone.y) / 2) + farthest_zone.y
              end
            end
            20.times do |i|
              radius = 10
              dx = rand(radius)
              dy = rand(radius)
              flip_dx = rand(2) == 0 ? -1 : 1
              flip_dy = rand(2) == 0 ? -1 : 1
              x = base_x + (flip_dx * dx)
              y = base_y + (flip_dy * dy)
              move  = Move.new(x, y, @player_id)
              move.score = @board.score(@player_id, {
                :moves => (all_moves + [move]),
                :zones => all_zones
              })
              puts "Move: #{move.to_coord.join(' ')}, score: #{move.score}"
              saved_moves << move
              if move.score > best_move.score
                best_move   = move
              end
              iter = i
            end
          end
          puts "Done! selecting best move #{best_move.to_coord.join(' ')} after #{iter + 1} choices"
        rescue Timeout::Error
          puts "Timeout! selecting best move #{best_move.to_coord.join(' ')} after #{iter + 1} choices"
        end
      end

      # filtered_moves = moves.select { |m| filter_move?(m.score, best_move.score) }

      best_move = moves.sort { |m_1, m_2| m_2.score <=> m_1.score }.first || best_move

      @board.add_move(best_move)

      best_move
    end

    protected

    def greedy_move?
      greedy = true
      defensive = false
      case player_id
      when 1
        case player_moves.size
        when 0
          greedy
        when 1..game_qtr
          defensive
        when (game_qtr + 1)..(2*game_qtr)
          defensive
        when (2*game_qtr + 1)..(3*game_qtr)
          defensive
        else
          defensive
        end
      else
        case player_moves.size
        when 0
          greedy
        when 1..(game_qtr*2 - 1)
          defensive
        when (game_qtr*2)..(game_qtr*3 - 1)
          defensive
        else
          greedy
        end
      end
    end

    def choose_strategy(greedy, defensive)
      case player_id
      when 1
        case player_moves.size
        when 0
          greedy
        when 1..game_qtr
          defensive
        when (game_qtr + 1)..(2*game_qtr)
          defensive
        when (2*game_qtr + 1)..(3*game_qtr)
          defensive
        else
          defensive
        end
      else
        case player_moves.size
        when 0
          defensive
        when 1..(game_qtr*2 - 1)
          defensive
        when (game_qtr*2)..(game_qtr*3 - 1)
          defensive
        else
          greedy
        end
      end
    end
    #
    def filter_move?(score, best_score)
      greedy_min    = GREEDY_MIN*best_score
      defensive_min = DEFENSE_MIN*best_score
      defensive_max = DEFENSE_MAX*best_score
      greedy    = greedy_min < score
      defensive = defensive_min < score && score <= defensive_max && defensive_prob
      if greedy || defensive
        choose_strategy(greedy, defensive)
      else
        false
      end
    end

    def zone_dimension
      player_move_count = player_moves.size
      return 10 if player_move_count < 2
      return 20 if player_move_count < 6
      40
    end

    def time_limit
      # @time_limits ||= begin
      #   increment = (TOTAL_TIME_LIMIT-move_count)/(1..move_count).inject(&:+)
      #   (1..move_count).map { |i| i*increment }
      # end
      # @time_limits[player_moves.size + 1]
      TOTAL_TIME_LIMIT / @move_count
    end

    def game_qtr
      @game_qtr ||= begin
        count   = move_count.odd? ? move_count + 1 : move_count
        count / 4
      end
    end

  end
end