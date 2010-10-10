require 'spec_helper'

describe Tipping::Position do
  before(:each) do
    Tipping::Game.stub!(:min => -15)
    Tipping::Game.stub!(:max => 15)
  end
  describe "place" do
    it "should place given weight at given location" do
      subject.place(1).at(-3)
      subject.board[-3].should == 1
    end
  end
  
end
