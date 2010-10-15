require 'spec_helper'

describe Tipping::Torque do
  before(:each) do
    @game = Tipping::Game.new
  end

  describe "self.calc" do

    it "should return weight * distance" do
      weight = 3
      distance = 12
      Tipping::Torque.calc(3, 12).should == 36
    end

  end

  describe "game torque" do
    before(:each) do
      @torque = Tipping::Torque.new(@game)
    end

    describe "no additional weight" do
      it "should equal -6/-6" do
        # starting position: weight 3 at -4, board weight 3 at 0
        position = @game.position

        # -6 (3 out-torque - 6 in-torque)
        @torque.out(position).should == -6
        # -9 (3 in-torque - 6 out-torque)
        @torque.in(position).should == -6
      end
    end

    describe "with weights" do
      it "should equal -9/-3" do
        position = @game.position
        position[0] = 3

        # -9 (3 out-torque - 18 in-torque)
        @torque.out(position).should == -15
        # -9 (6 in-torque - 9 out-torque)
        @torque.in(position).should == -3
      end
    end

  end

end
