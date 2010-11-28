require 'spec_helper'

describe DatingGame::Dispatch do
  describe "person_weights" do
    it "should return weights b/w 0 and 1 adding up to 1" do
      ups = subject.up_weights(10)
      ups.size.should == 10
      ups.uniq.size.should == 10
      sum = ups.inject(&:+)
      sum.should == 1.0
    end
    it "should return weights b/w -1 and 0 adding up to -1" do
      downers = subject.down_weights(10)
      downers.size.should == 10
      downers.uniq.size.should == 10
      sum = downers.inject(&:+)
      sum.should == -1.0
    end
  end
end
