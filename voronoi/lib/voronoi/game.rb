module Voronoi

  class Game
    include Utils::Timer
    
    MAX_SCORE = 1.0
    GREEDY_MIN = 0.9
    BEST_GREEDY_MIN = 0.9
    DEFENSE_MIN = 0.5
    BEST_DEFENSE_MIN = 0.525
    DEFENSE_MAX = 0.55
    TOTAL_TIME_LIMIT = 120

    attr_reader :board, :size, :move_count, :players, :player_id
    def initialize(size, move_count, players, player_id)
      @size       = size
      @move_count = move_count
      @players    = players
      @player_id  = player_id
      @board      = Board.new({
                      :size => [size,size],
                      :players => 2
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

      best_move = Move.worst_move
      moves = [].tap do |saved_moves|
        begin
          
          iter = 0
          with_timeout time_limit do
            250.times do |i|
              move  = Move.new(rand(@size), rand(@size), @player_id)
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

      filtered_moves = moves.select { |m| filter_move?(m.score, best_move.score) }

      # select with probability
      best_move = select_weighted_move(filtered_moves, best_move.score)

      @board.add_move(best_move)

      best_move
    end

    protected

    def select_weighted_move(moves, best_score)
      greedy_range = (BEST_GREEDY_MIN*best_score)..best_score
      defensive_range = BEST_DEFENSE_MIN*best_score..DEFENSE_MAX*best_score
      greedy_weight, defensive_weight = move_weights
      weighted_moves = moves.map { |move|
        weight = case move.score
        when greedy_range
          greedy_weight
        when defensive_range
          defensive_weight
        else
          1
        end
        Array.new(weight, move)
      }.flatten
      weighted_moves[rand(weighted_moves.size)]
    end

    def move_weights
      case player_id
      when 1
        case player_moves.size
        when 0..game_qtr
          [1,0]
        when (game_qtr + 1)..(2*game_qtr)
          [2,1]
        when (2*game_qtr + 1)..(3*game_qtr)
          [1,2]
        else
          [1,4]
        end
      else
        case player_moves.size
        when 0..(game_qtr*2 - 1)
          [1,0]
        when (game_qtr*2)..(game_qtr*3 - 1)
          [2,1]
        else
          [1,0]
        end
      end
    end

    def filter_move?(score, best_score)
      greedy_min    = GREEDY_MIN * best_score
      defensive_min = DEFENSE_MIN*best_score
      defensive_max = DEFENSE_MAX*best_score
      greedy_prob   = rand(score - greedy_min) > rand(best_score - score)
      defensive_prob = rand(score - defensive_min) > rand(defensive_max - score)
      greedy    = greedy_min < score && greedy_prob
      defensive = defensive_min < score && score <= defensive_max && defensive_prob
      case player_id
      when 1
        return greedy if player_moves.size < game_qtr + 1
        return greedy || defensive
      when 2
        return greedy if player_moves.size < game_qtr + 1
        return (greedy || defensive) if player_moves.size < (game_qtr * 3)
        return greedy
      else
        return greedy
      end
    end

    def zone_dimension
      player_move_count = player_moves.size
      return 10 if player_move_count < 2
      return 25 if player_move_count < 4
      return 40 if player_move_count < 6
      return 50 if player_move_count < 8
      100
    end

    def time_limit
      @time_limits ||= begin
        buffer = move_count
        increment = (TOTAL_TIME_LIMIT-move_count)/(1..move_count).inject(&:+)
        (1..move_count).map { |i| i*increment }
      end
      @time_limits[player_moves.size + 1]
    end
    
    def game_qtr
      @game_qtr ||= begin
        count   = move_count.odd? ? move_count + 1 : move_count
        count / 4
      end
    end

  end
end