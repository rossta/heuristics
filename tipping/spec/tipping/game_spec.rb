require 'spec_helper'

describe Tipping::Game do
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

end
