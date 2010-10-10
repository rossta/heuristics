require 'spec_helper'

describe Tipping::Torque do
  before(:each) do
    @game = mock(Tipping::Game)
    @game.stub!(:min => -15)
    @game.stub!(:max => 15)
    @game.stub!(:left_support => -3)
    @game.stub!(:right_support => -1)
    @game.stub!(:weight => 3)
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
      it "should equal -9/-3" do
        position = { }
        # -9 (0 out-torque - 9 in-torque)
        @torque.left(position).should == -9
        # -9 (3 out-torque - 0 in-torque)
        @torque.right(position).should == -3
      end
    end

    describe "with weights" do
      it "should equal -9/-3" do
        position = { }
        position[-4] = 3
        # -9 (0 out-torque - 9 in-torque)
        @torque.left(position).should == -6
        # -9 (3 out-torque - 0 in-torque)
        @torque.right(position).should == 6
      end
    end
    
  end

end
