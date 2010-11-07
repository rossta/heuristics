module Voronoi

  class Game
    GREEDY_MIN = 0.9
    DEFENSE_MIN = 0.5
    DEFENSE_MAX = 0.55

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
        20.times do
          move  = Move.new(rand(@size), rand(@size), @player_id)
          move.score = @board.score(@player_id, {
            :moves => (all_moves + [move]),
            :zones => all_zones
          })
          puts "Move: #{move.to_coord.to_s}, score: #{move.score}"
          saved_moves << move
          if move.score > best_move.score
            best_move   = move
          end
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
      greedy_range = (GREEDY_MIN*best_score)..best_score
      defensive_range = DEFENSE_MIN*best_score..DEFENSE_MAX*best_score
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
        when 0..2
          [4,1]
        when 3..4
          [2,1]
        when 5..6
          [1,2]
        else
          [1,4]
        end
      else
        case player_moves.size
        when 0..3
          [4,1]
        when 4..5
          [2,1]
        else
          [4,1]
        end
      end
    end

    def filter_move?(score, best_score)
      greedy    = (GREEDY_MIN * best_score) < score
      defensive = ((DEFENSE_MIN*best_score) < score && score <= (DEFENSE_MAX*best_score))
      case player_id
      when 1
        return greedy if player_moves.size < 3
        return greedy || defensive
      when 2
        return greedy if player_moves.size < 3
        return (greedy || defensive) if player_moves.size < 6
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

  end
end