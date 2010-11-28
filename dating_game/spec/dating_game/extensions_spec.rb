require 'spec_helper'

describe "Extensions" do
  describe Math do
    describe "log2" do
      it "should return 3 for log2 8" do
        subject.log2(8).should == 3
      end
      it "should return 6 for log2 64" do
        subject.log2(64).should == 6
      end
    end
    
  end
end
