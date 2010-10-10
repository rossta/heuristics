require 'spec_helper'

describe Tipping::Game do
  describe "defaults" do
    it "should have range 15" do
      subject.range.should == 15
    end
    it "should have locations -15 to 15" do
      subject.locations.size.should == 31
      subject.locations.first.should == -15
      subject.locations.last.should == 15
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

  describe "available_moves" do
    it "should return moves for open locations and unused weights" do
      @game = Tipping::Game.new({
        :blocks => 5,
        :range => 5
      })
      @position = Tipping::Position.new(@game)
      @game.available_moves(@position).size.should == 55
    end
  end

end
