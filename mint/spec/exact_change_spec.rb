require File.dirname(__FILE__) + '/spec_helper'

describe Mint::ExactChange do
  
  describe "probability of multiple of 5 price is" do
    
    describe "equal" do
      it "should return total exact change of 329 with coin set 1, 5, 16, 23, 33" do
        exact_change = Mint::ExactChange.new(1)
        exact_change.calculate!
        exact_change.results.should == 329
        exact_change.coin_set.should == [1, 5, 16, 23, 33]
      end
    end

    describe "3 times higher" do
      it "should return total exact change of 427 with coin set 1, 5, 19, 25, 40" do
        exact_change = Mint::ExactChange.new(3)
        exact_change.calculate!
        exact_change.results.should == 430
        exact_change.coin_set.should == [1, 5, 18, 25, 40]
      end
    end
    
    describe "4 times higher" do
      it "should return total exact change of 475 with coin set 1, 5, 19, 25, 40" do
        exact_change = Mint::ExactChange.new(4)
        exact_change.calculate!
        exact_change.results.should == 475
        exact_change.coin_set.should == [1, 5, 19, 25, 40]
      end
    end
    
    describe "5 times higher" do
      it "should return total exact change of 520 with coin set 1, 5, 19, 25, 40" do
        exact_change = Mint::ExactChange.new(5)
        exact_change.calculate!
        exact_change.results.should == 520
        exact_change.coin_set.should == [1, 5, 19, 25, 40]
      end
    end

    describe "100 times higher" do
      it "should return total exact change of 4360 with coin set 1, 5, 10, 30, 45" do
        exact_change = Mint::ExactChange.new(100)
        exact_change.calculate!
        exact_change.results.should == 4360
        exact_change.coin_set.should == [1, 5, 10, 30, 45]
      end
    end

    describe "2398172398 times higher" do
      it "should return total exact change of 103520 with coin set 1, 5, 10, 30, 45" do
        exact_change = Mint::ExactChange.new(2398172398)
        exact_change.calculate!
        exact_change.results.should == 95926896280
        exact_change.coin_set.should == [1, 5, 10, 30, 45]
      end
    end

    describe "0.01 times higher" do
      it "should return total exact change of 261 with coin set 1, 4, 9, 29, 44" do
        exact_change = Mint::ExactChange.new(0.01)
        exact_change.calculate!
        exact_change.results.should == 261
        exact_change.coin_set.should == [1, 4, 9, 29, 44]
      end
    end
    
    describe "0.00231 times higher" do
      it "should return total exact change of 261 with coin set 1, 4, 9, 29, 44" do
        exact_change = Mint::ExactChange.new(0.00231)
        exact_change.calculate!
        exact_change.results.should == 261
        exact_change.coin_set.should == [1, 4, 9, 29, 44]
      end
    end
    
  end
end
