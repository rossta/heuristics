require 'spec_helper'

describe Evasion::Wall do
  describe "intersects?" do
    describe "vertical wall" do
      before(:each) do
        @wall = Evasion::Wall.new(:wall, 0, 0, 0, 500)
      end
      
      it "should return true if given coords on wall" do
        @wall.intersects?(0, 100).should be_true
      end
    
      it "should return false if given coords not on wall" do
        @wall.intersects?(100, 0).should be_false
      end
    end
    describe "horizontal wall" do
      before(:each) do
        @wall = Evasion::Wall.new(:wall, 0, 0, 500, 0)
      end
      
      it "should return true if given coords on wall" do
        @wall.intersects?(0, 100).should be_false
      end
    
      it "should return false if given coords not on wall" do
        @wall.intersects?(100, 0).should be_true
      end
    end
    
    describe "to_coord" do
      it "should return string NAME (x1, y1), (x2, y2)" do
        @wall = Evasion::Wall.new(:wall, 0, 0, 0, 500)
        @wall.to_coord.should == "wall (0, 0), (0, 500)"
      end
    end
  end
end
