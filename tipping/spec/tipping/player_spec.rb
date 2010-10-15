require 'spec_helper'

describe Tipping::Player do

  describe "choose_best_move" do
    it "should return alpha beta move" do
      pending
    end
  end
  
  describe "initialize" do
    it "should have blocks for given block range" do
      player = Tipping::Player.new(Tipping::Game.new(:max_block => 10))
      player.blocks.should == [1,2,3,4,5,6,7,8,9,10]
    end
  end
end
