require File.dirname(__FILE__) + '/spec_helper'

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
end

describe Salesman::SpanTree do

  describe "build" do
    before(:each) do
      @cities, @edges = [], []
      5.times { |i| @cities << Salesman::City.new(i, i + 1, i + 2, i + 3) }
      @cities.each_with_index do |city, i|
        j = i + 1
        while j < @cities.size
          @edges << Salesman::Edge.new(city, @cities[j])
          j += 1
        end
      end
      @edges.sort!
      @tree = Salesman::SpanTree.new(@cities, @edges)
      @tree.build
    end

    it "should build array of array of tree cities n and tree edges size n - 1" do
      @tree.size.should == @cities.size
      @tree.edges.size.should == @cities.size - 1
    end

    it "should increment edge count of cities" do
      first_city = @cities.first
      edge_count = 0
      @tree.edges.each do |edge|
        edge_count += 1 if edge.a == first_city
        edge_count += 1 if edge.b == first_city
      end
      @tree.edge_count(first_city).should == edge_count
    end

    describe "odd_cities" do
      it "should return list of cities with odd edge counts" do
        # name: 0, count 1
        # name: 1, count 2
        # name: 2, count 2
        # name: 3, count 2
        # name: 4, count 1
        @tree.odd_cities.should include(@cities.first)
        @tree.odd_cities.should include(@cities.last)
        # @tree.odd_cities.should_not include?(@cities.second)
      end
    end
  end
end