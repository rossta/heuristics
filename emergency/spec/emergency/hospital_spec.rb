require 'spec_helper'

describe Emergency::Hospital do

  describe "initialize" do
    it "should create ambulances for given count" do
      hosp = Emergency::Hospital.new(5)
      hosp.ambulances.size.should == 5
      hosp.ambulances.first.should be_a(Emergency::Ambulance)
    end
  end

  describe "update_position" do
    it "should set x and y values if given as options" do
      hosp_1 = Emergency::Hospital.new(5)
      hosp_2 = Emergency::Hospital.new(5)

      hosp_1.update_position({:x => 1, :y => 2})
      hosp_2.update_position({:x => 3, :y => 4})

      hosp_1.x.should == 1
      hosp_1.y.should == 2

      hosp_2.x.should == 3
      hosp_2.y.should == 4
    end
  end

end

describe Emergency::Ambulance do
  
  describe "any_saveable?" do
    
    it "should return true" do
      
    end
    
  end
end
