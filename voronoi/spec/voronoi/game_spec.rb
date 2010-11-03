require 'spec_helper'

describe Voronoi::Game do
  describe "initialize" do
    it "should set moves, players, and player_id" do
      game = Voronoi::Game.new(7, 2, 1)
      game.moves.should == 7
      game.players.should == 2
      game.player_id.should == 1
    end
  end
end
