require 'spec_helper'

describe Emergency::Edge do

  before(:each) do
    @p1 = Emergency::Position.new(0, 0)
    @p2 = Emergency::Position.new(1, 1)
    @p3 = Emergency::Position.new(2, 2)
    @p4 = Emergency::Position.new(0, 0)
  end

  describe "matches?" do
    it "should return false if positions don't match" do
      edge = Emergency::Edge.new(@p1, @p2)
      edge.matches?(@p2, @p3).should be_false
    end

    it "should return true if positions match but switched" do
      edge = Emergency::Edge.new(@p1, @p2)
      edge.matches?(@p2, @p1).should be_true
    end

    it "should return true if positions diff objs but same x, y" do
      edge = Emergency::Edge.new(@p1, @p2)
      edge.matches?(@p4, @p2).should be_true
    end
  end
  
  describe "distance" do
    
    it "should equal distance from a to b" do
      edge = Emergency::Edge.new(@p1, @p2)
      edge.distance.should == 2
    end
  end
end
