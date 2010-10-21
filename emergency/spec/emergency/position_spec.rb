require 'spec_helper'

describe Emergency::Position do

  describe "self.center" do
    it "should return a new position halfway between two given ones" do
      pos_1   = Emergency::Position.new(10, 10)
      pos_2   = Emergency::Position.new(20, 20)
      center  = Emergency::Position.center(pos_1, pos_2)
      center.x.should == 15
      center.y.should == 15

      pos_3   = Emergency::Position.new(20, 20)
      pos_4   = Emergency::Position.new(10, 10)
      center  = Emergency::Position.center(pos_3, pos_4)
      center.x.should == 15
      center.y.should == 15
    end
  end
  
  describe "distance_to" do
    it "should calc distance between first and second position" do
      pos_1   = Emergency::Position.new(10, 10)
      pos_2   = Emergency::Position.new(20, 20)
      pos_1.distance_to(pos_2).should == 20
      pos_2.distance_to(pos_1).should == 20
    end
  end
  
end
