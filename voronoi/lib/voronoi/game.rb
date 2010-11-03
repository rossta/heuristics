module Voronoi
  
  class Game
    attr_reader :moves, :players, :player_id
    def initialize(moves, players, player_id)
      @moves = moves
      @players = players
      @player_id = player_id
    end
  end
end