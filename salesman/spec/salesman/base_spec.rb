require File.dirname(__FILE__) + '/../spec_helper'

describe Salesman::Edge do

  describe "<=>" do
    it "should compare based on distance" do
      e_1 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_1.stub!(:distance => 5)
      e_2 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_2.stub!(:distance => 10)
      e_3 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_3.stub!(:distance => 5)

      (e_1 <=> e_2).should == -1
      (e_2 <=> e_1).should == 1
      (e_1 <=> e_3).should == 0
    end
  end

  describe "cities" do
    it "should return array of cities" do
      c_1 = mock(Salesman::City)
      c_2 = mock(Salesman::City)
      edge = Salesman::Edge.new(c_1, c_2)
      edge.cities.should == [c_1, c_2]
    end
  end

  describe "total_distance" do
    before(:each) do
      @base = Salesman::Base.new
      @tree = mock(Salesman::SpanTree, :distance => 200)
      @match = mock(Salesman::MatchGraph, :distance => 100)
      @tour = mock(Salesman::EulerTour, :distance => 250)
      @base.tree = @tree
      @base.match = @match
      @base.tour = @tour
    end
    describe "tour present" do
      it "should return tour distance" do
        @base.total_distance.should == 250
      end
    end

    describe "tour not present" do
      before(:each) do
        @base.tour = nil
      end
      it "should return tree distance + match distance if tree and match present" do
        @base.total_distance.should == 300
      end
      it "should return tree distance if only tree" do
        @base.match = nil
        @base.total_distance.should == 200
      end

      it "should return nil otherwise" do
        @base.tree = nil
        @base.match = nil
        @base.total_distance.should be_nil
      end
    end
  end
end
