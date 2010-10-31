require File.dirname(__FILE__) + '/../spec_helper'

describe Emergency::Base do

  describe "Parser" do
    it "should create people, hospitals" do
      parser = Emergency::Parser.new('doc/ambu10')
      people, hospitals = parser.parse
      people.size.should == 300
      hospitals.size.should == 5
      hospitals.first.ambulances.size.should == 5
    end
  end

  describe "Grid" do

    describe "cluster" do
      it "should return num of positions for given num of clusters" do
        grid = Emergency::Grid.create([
          [1,6,10],[2,7,11],[3,8,12],[4,9,13],[5,10,14],[11,16,15],[12,17,16],[13,18,17],[14,19,18],[15,20,19]
        ])

        centroids = grid.centroids(3)
        centroids.size.should == 3
        centroids.first.should be_a(Emergency::Position)
      end
    end
  end
end
