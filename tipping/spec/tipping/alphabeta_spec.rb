require File.dirname(__FILE__) + '/../spec_helper'

describe Tipping::AlphaBeta do

  describe "self.score" do

    describe "min node" do
      it "should return lowest value of children" do
        state_a = Tipping::GameState.min
        state_b = Tipping::GameState.max
        state_c = Tipping::GameState.max
        state_a.children = [state_b, state_c]
        state_b.stub!(:score => 1)
        state_c.stub!(:score => 2)
    
        Tipping::AlphaBeta.score(state_a).should == 1
      end
    end
    
    describe "max node" do
      it "should return highest value of children" do
        state_a = Tipping::GameState.max
        state_b = Tipping::GameState.min
        state_c = Tipping::GameState.min
        state_a.children = [state_b, state_c]
        state_b.stub!(:score => 1)
        state_c.stub!(:score => 2)

        Tipping::AlphaBeta.score(state_a).should == 2
      end
    end

  end
end
