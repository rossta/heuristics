require 'spec_helper'

describe Emergency::Ambulance do

  before(:each) do
    hospital = stub(Emergency::Hospital, :position => Emergency::Position.new(0, 0))
    Emergency::Clock.stub!(:tick)
    Emergency::Clock.stub!(:time).and_return(10)
    Emergency::Logger.stub!(:record)
    @person = Emergency::Person.new(10, 10, 100)
    @amb = Emergency::Ambulance.new(hospital)
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
    end

    it "should move to person's position after clock tick" do
      @amb.pickup @person
      @amb.position.x.should == @person.position.x
      @amb.position.y.should == @person.position.y
    end

    it "should set ambulance time to clock time" do
      @amb.pickup @person
      @amb.time.should == 21
    end
  end
end
