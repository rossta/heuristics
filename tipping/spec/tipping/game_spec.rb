require 'spec_helper'

describe Tipping::Game do
  
  describe "score" do
    
    describe "red strategy: going first" do
      it "should force bad endgame for blue" do
        pending
      end
    end
    
    describe "blue strategy: going last" do
      it "should prevent bad endgame" do
        pending
      end
    end
  end
  
  describe "defaults" do
    it "should have range 15" do
      subject.range.should == 15
    end
    it "should have locations -15 to 15" do
      subject.locations.size.should == 31
      subject.locations.first.should == -15
      subject.locations.last.should == 15
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
        :max_block    => 5,
        :range        => 5
      })
      @position = Tipping::Position.new(@game)
      @game.available_moves(@position, :player).size.should == 55
    end

    it "should return moves representing placing unused weights at each open location one at a time" do
      @game = Tipping::Game.new({
        :max_block  => 5,
        :range      => 5
      })
      @position = Tipping::Position.new(@game)
      @position[-4] = 3
      @position[1]  = @game.player.blocks.delete(1)
      @position[-1] = @game.opponent.blocks.delete(1)
      
      open_slots    = @position.open_slots.size
      unused_blocks = @game.player.blocks.size
      @game.available_moves(@position, :player).size.should == open_slots * unused_blocks
    end
  end
  
  describe "complete_move" do
    describe "player" do
      it "should update player's available blocks" do
        pending
      end
      
      it "should update game position" do
        pending
      end
    end
    
    describe "opponent" do
      it "should update oppponent's available blocks" do
        pending
      end
      
      it "should update game position" do
        pending
      end
    end
    
  end

end
