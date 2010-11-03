require 'spec_helper'

describe Voronoi::Move do
  describe "initialize" do
    it "should have x, y, player_id" do
      move = Voronoi::Move.new(5,6,1)
      move.x.should == 5
      move.y.should == 6
      move.player_id.should == 1
    end
  end
  
  describe "to_coord" do
    it "should return [x,y]" do
      Voronoi::Move.new(5,6,1).to_coord.should == [5,6]
    end
  end
  
end
