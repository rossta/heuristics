require 'spec_helper'

describe Emergency::Clock do
  
  after(:each) do
    Emergency::Clock.reset
  end
  describe "tick" do
    it "should add given time to Clock" do
      Emergency::Clock.tick(50)
      Emergency::Clock.time.should == 50
    end
  end
  
  describe "reset" do
    it "should reset time to 0" do
      Emergency::Clock.tick(50)
      Emergency::Clock.reset
      Emergency::Clock.time.should == 0
    end
  end
end
