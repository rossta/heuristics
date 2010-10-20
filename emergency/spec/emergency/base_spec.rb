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
end
