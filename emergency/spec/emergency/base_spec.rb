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
        grid = Emergency::Grid.create([1,2,3,4,5], [6,7,8,9,10])
        grid.sw.x.should == 1
        grid.sw.y.should == 6
        grid.ne.x.should == 5
        grid.ne.y.should == 10
      end
    end
  end
end
