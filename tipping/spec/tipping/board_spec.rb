require 'spec_helper'

describe Tipping::Board do
  describe "defaults" do
    it "should have length 30" do
      subject.length.should == 30
    end
    it "should give player and opponent 10 weights, 1..10" do
      subject.opponent_blocks.should == (1..10).to_a
      subject.player_blocks.should == (1..10).to_a
    end
    it "should have weight 3" do
      subject.weight.should == 3
    end
    it "should have supports at positions -3 and -1" do
      subject.left_support.should   == -3
      subject.right_support.should  == -1
    end
  end

  describe "place" do
    it "should place given weight at given location" do
      subject.place(1).at(-3)
      subject.position[-3].should == 1
    end
  end

  describe "torque" do
    describe "no additional weight" do
      it "should equal -9/-3" do
        # -9 (0 out-torque - 9 in-torque)
        subject.left_torque.should == -9
        # -9 (3 out-torque - 0 in-torque)
        subject.right_torque.should == -3
      end
    end
    
    describe "place 3 at -4" do
      it "should equal -6/6" do
        subject.place(3).at(-4)
        # -9 (3 out-torque - 9 in-torque)
        subject.left_torque.should == -6
        # 6 (9 out-torque - 3 out-torque)
        subject.right_torque.should == 6
      end
    end
  end
end
