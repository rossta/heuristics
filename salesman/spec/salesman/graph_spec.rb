require File.dirname(__FILE__) + '/../spec_helper'

describe Salesman::Graph do

  def initialize_cities_and_edges
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
  end
  
  describe "EulerTour" do
    describe "travel" do
      it "should connect a-b, b-c, c-d, d-b, b-e" do
        city_1 = Salesman::City.new("1", 1, 1, 0)
        city_2 = Salesman::City.new("2", 2, 0, 0)
        city_3 = Salesman::City.new("3", 2, 2, 0)
        city_4 = Salesman::City.new("4", 0, 2, 0)
        city_5 = Salesman::City.new("5", 0, 0, 0)
        edge_1 = Salesman::Edge.new(city_1, city_2)
        edge_2 = Salesman::Edge.new(city_1, city_3)
        edge_3 = Salesman::Edge.new(city_1, city_4)
        edge_4 = Salesman::Edge.new(city_1, city_5)
        edge_5 = Salesman::Edge.new(city_3, city_4)
        edge_6 = Salesman::Edge.new(city_2, city_5)
        tree_edges = [edge_1, edge_2, edge_3, edge_4]
        match_edges = [edge_5, edge_6]
        tour = Salesman::EulerTour.new(tree_edges, match_edges)
        tour.travel!
        tour.edges.size.should == 5
        tour.edges.should == [edge_4, edge_2, edge_5, edge_3, edge_1]
        tour.cities.size.should == 6
        tour.cities.should == [city_5, city_1, city_3, city_4, city_1, city_2]
      end
    end
  end
  

  describe "MatchGraph" do
    describe "build" do
      before(:each) do
        initialize_cities_and_edges
        @match = Salesman::MatchGraph.new([@cities.first, @cities.last], @edges)
        @match.build
      end

      it "should link all cities with one edge" do
        @match.cities.each do |city|
          @match.edge_count(city).should == 1
        end
      end

      it "total edge count should be half city count" do
        @match.edges.size.should == @match.cities.size / 2
      end
    end
  end

  describe "SpanTree" do
    describe "build" do
      before(:each) do
        initialize_cities_and_edges
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
          @tree.odd_cities.should_not include(@cities[1])
          @tree.odd_cities.should_not include(@cities[2])
          @tree.odd_cities.should_not include(@cities[3])
        end
      end
    end
  end
end