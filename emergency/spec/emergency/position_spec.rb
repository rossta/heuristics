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

end
