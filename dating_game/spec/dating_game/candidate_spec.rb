require 'spec_helper'

describe DatingGame::Candidate do
  
  describe "to_msg" do
    it "should return :-delimited list of attributes" do
      subject.attrs = [0.1, 0.2, 0.3, 0.4, 0.5]
      subject.to_msg.should == "0.1:0.2:0.3:0.4:0.5"
    end
  end
end
