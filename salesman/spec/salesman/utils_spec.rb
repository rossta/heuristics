require File.dirname(__FILE__) + '/../spec_helper'

describe Salesman::Measure do

  describe "distance" do
    it "should return 5 distance (0, 0, 5) and (0, 0, 0)" do
      Salesman::Measure.distance([0, 0, 5], [0, 0, 0]).should == 5
    end
    it "should return 5 distance (0, 5, 0) and (0, 0, 0)" do
      Salesman::Measure.distance([0, 5, 0], [0, 0, 0]).should == 5
    end
    it "should return 5 distance (5, 0, 0) and (0, 0, 0)" do
      Salesman::Measure.distance([5, 0, 0], [0, 0, 0]).should == 5
    end
    it "should return 5 distance (3, 0, 0) and (0, 4, 0)" do
      Salesman::Measure.distance([3, 0, 0], [0, 4, 0]).should == 5
    end
    it "should return 5 distance (10, 4, 6) and (1, 7, 12)" do
      Salesman::Measure.distance([10, 4, 6], [1, 7, 12]).should == Math.sqrt(126)
    end
  end

  describe "score" do
    it "should return sum of abs val difference of each coord" do
      Salesman::Measure.score([0, 0, 5], [0, 0, 0]).should == 5
      Salesman::Measure.score([10, 4, 6], [1, 7, 12]).should == 9 + 3 + 6
    end
  end
end
