require 'spec_helper'

describe DatingGame::Matchmaker do
  describe "parse_candidate" do
    before(:each) do
      @candidate = mock(DatingGame::Candidate, :score= => nil, :attrs= => nil)
      DatingGame::Candidate.stub!(:new).and_return(@candidate)
    end
    it "should add to list of candidates" do
      response = "0.23:0.76:0.06:0.78:0.13:0.57"
      subject.parse_candidate(*response.split(":"))
      subject.candidates.size.should == 1
    end
    it "should add a new candidate and assign score, attrs" do
      response = "0.23:0.76:0.06:0.78:0.13:0.57"
      DatingGame::Candidate.should_receive(:new).and_return(@candidate)
      @candidate.should_receive(:score=).with(0.23)
      @candidate.should_receive(:attrs=).with([0.76,0.06,0.78,0.13,0.57])
      subject.parse_candidate(*response.split(":"))
    end
  end
  
  describe "next_candidate" do
    it "should return a candidate" do
      subject.attr_count = 5
      subject.parse_candidate *("0.23:0.76:0.06:0.78:0.13:0.57").split(":")
      subject.parse_candidate *("0.45:0.99:0.79:0.30:0.00:0.24").split(":")
      subject.parse_candidate *("0.58:0.82:0.38:0.48:0.93:0.25").split(":")
      subject.next_candidate.should be_a(DatingGame::Candidate)
    end
  end
end
