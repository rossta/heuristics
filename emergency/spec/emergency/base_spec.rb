require File.dirname(__FILE__) + '/../spec_helper'

describe Emergency::Base do

  describe "Parser" do
    it "should create people, hospitals" do
      parser = Emergency::Parser.new('doc/ambu2010')
      people, hospitals = parser.parse
      people.size.should == 300
      hospitals.size.should == 5
      hospitals.first.ambulances.size.should == 5
    end
  end

  describe "Grid" do
    describe "create" do
      it "should create a new grid from x, y lists" do
        grid = Emergency::Grid.create([[1,6],[2,7],[3,8],[4,9],[5,10]])
        grid.sw.x.should == 1
        grid.sw.y.should == 6
        grid.ne.x.should == 5
        grid.ne.y.should == 10
      end
    end

    describe "cluster" do
      it "should return num of positions for given num of clusters" do
        grid = Emergency::Grid.create([
          [1,6],[2,7],[3,8],[4,9],[5,10],[11,16],[12,17],[13,18],[14,19],[15,20]
        ])

        centroids = grid.centroids(3)
        centroids.size.should == 3
        centroids.first.should be_a(Emergency::Position)
      end
    end
  end
end
