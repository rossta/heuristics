module Tipping

  class Score

    def self.conservative(game)
      game.locations.inject(0) { |sum, loc|
        sum += game.position[loc].to_i * ((game.left_support - loc).abs + (game.right_support - loc).abs)
      }
    end

    def self.tippers(game, player_type)
      other_player = player_type == PLAYER ? OPPONENT : PLAYER
      tip_count = 0
      position = game.position
      position.available_moves(other_player).each do |move|
        position.do! move
        tip_count += 1 if position.tipped?
        position.undo! move
      end
      tip_count
    end

  end
end