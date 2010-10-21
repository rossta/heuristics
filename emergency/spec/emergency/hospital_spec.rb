require 'spec_helper'

describe Emergency::Hospital do

  before(:each) do
    Emergency::Clock.stub!(:tick)
  end
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

  before(:each) do
    Emergency::Clock.stub!(:tick)
    Emergency::Clock.stub!(:time).and_return(10)
    @person = Emergency::Person.new(10, 10, 100)
    @amb = Emergency::Ambulance.new
    @amb.position = Emergency::Position.new(0, 0)
  end

  describe "pickup" do

    it "should add person to patient list" do
      @amb.pickup @person
      @amb.patients.size.should == 1
      @amb.patients.first.should == @person
    end

    it "should add to total time" do
      distance = @amb.distance_to(@person)
      distance.should == 20
      Emergency::Clock.should_receive(:tick).with((distance + Emergency::Ambulance::LOAD_TIME))
      @amb.pickup @person
    end

    it "should move to person's position after clock tick" do
      @amb.pickup @person
      @amb.position.x.should == @person.position.x
      @amb.position.y.should == @person.position.y
    end

    it "should set ambulance time to clock time" do
      Emergency::Clock.stub!(:time).and_return(20)
      @amb.pickup @person
      @amb.time.should == 20
    end
  end
end
