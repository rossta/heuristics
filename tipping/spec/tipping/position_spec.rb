require 'spec_helper'

describe Tipping::Position do
  before(:each) do
    @position = Tipping::Position.new
    Tipping::Game.stub!(:min => -15)
    Tipping::Game.stub!(:max => 15)
  end

  describe "[]" do
    it "should place given weight at given location" do
      @position[-3] = 1
      @position[-3].should == 1
    end
  end

  describe "available_moves" do

    it "should return all moves possible from current position" do
      move_1 = mock(Tipping::Move)
      move_2 = mock(Tipping::Move)
      available_moves = [move_1, move_2]
      @position.game.should_receive(:available_moves).with(@position).and_return(available_moves)
      @position.available_moves.should == available_moves
    end
  end

end

describe Tipping::Move do

  describe "perform move" do
    before(:each) do
      @position = Tipping::Position.new
      @move = Tipping::Move.new(-3, 5, @position)
    end

    describe "do" do
      it "should perform move on current position" do
        @move.do
        @position[5].should == -3
      end

      it "should be done after do" do
        @move.do
        @move.done?.should be_true
      end

      it "should not be done before do" do
        @move.done?.should be_false
      end
    end

    describe "undo" do
      it "should undo move on current position" do
        @move.do
        @move.undo
        @position[5].should be_nil
      end

      it "should not be done after undo" do
        @move.do
        @move.undo
        @move.done?.should be_false
      end
    end

  end

  describe "<=>" do
    before(:each) do
      @position_1 = Tipping::Position.new
      @position_2 = Tipping::Position.new
      @move_1 = Tipping::Move.new(1, 4, @position_1)
      @move_2 = Tipping::Move.new(4, 1, @position_2)
    end

    after(:each) do
      @move_1.undo
      @move_2.undo
    end

    it "should ensure do was called" do
      @position_1.stub!(:current_score => 10)
      @position_2.stub!(:current_score => 20)
      @move_1 <=> @move_2
      @move_1.done?.should be_true
      @move_2.done?.should be_true
    end

    it "should return -1 if this move is worse than other" do
      @position_1.stub!(:current_score => 10)
      @position_2.stub!(:current_score => 20)
      (@move_1 <=> @move_2).should == -1
    end

    it "should return +1 if this move is better than other" do
      @position_1.stub!(:current_score => 20)
      @position_2.stub!(:current_score => 10)
      (@move_1 <=> @move_2).should == 1
    end

    it "should return 0 if this move is equal other" do
      @position_1.stub!(:current_score => 10)
      @position_2.stub!(:current_score => 10)
      (@move_1 <=> @move_2).should == 0
    end
  end

end
