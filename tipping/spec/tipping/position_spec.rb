require 'spec_helper'

describe Tipping::Position do
  before(:each) do
    @position = Tipping::Position.new
  end

  describe "[]" do
    it "should place given weight at given location" do
      @position[-3] = 1
      @position[-3].should == 1
    end
  end

  describe "update_all" do
    it "should set all board locations/weights to new given keys/values" do
      @position.update_all({
        -4  => 3,
         2  => 1,
        -1  => 10
      })
      @position[-4].should == 3
      @position[2].should == 1
      @position[-1].should == 10
      unoccupied = (-15..-5).to_a + [-3, -2] + [0, 1] + (3..15).to_a
      unoccupied.each do |loc|
        @position[loc].should == nil
      end
    end
  end

  describe "available_moves" do

    it "should return all moves possible from current position" do
      move_1 = mock(Tipping::Move)
      move_2 = mock(Tipping::Move)
      available_moves = [move_1, move_2]
      @position.game.should_receive(:available_moves).with(@position, :player).and_return(available_moves)
      @position.available_moves(:player).should == available_moves
    end
  end

  describe "open_slots" do
    describe "empty board" do
      it "return all open slots between min and max" do
        locations = (-5..5).to_a
        @game = mock(Tipping::Game, :max => 5, :min => -5, :locations => locations)
        @position = Tipping::Position.new(@game)
        @position.open_slots.should == locations
      end
    end
    describe "spots filled" do
      it "return all open slots between min and max" do
        locations = (-5..5).to_a
        @game = mock(Tipping::Game, :max => 5, :min => -5, :locations => locations)
        @position = Tipping::Position.new(@game)
        @position[-4] = 4
        @position[3]  = 2
        open_slots = locations.dup
        open_slots.delete(-4)
        open_slots.delete(3)
        @position.open_slots.should == open_slots
      end
    end
  end
end

describe Tipping::Move do

  describe "perform move" do
    before(:each) do
      @position = Tipping::Position.new
      @move = Tipping::Move.new(-3, 5, :player)
    end

  end

end
