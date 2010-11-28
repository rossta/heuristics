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
end
