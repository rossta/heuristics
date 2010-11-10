require 'spec_helper'

describe Evasion::Game do
  describe "initialize" do
    it "should create a players" do
      hunter = stub(Evasion::Hunter)
      prey = stub(Evasion::Prey)
      Evasion::Hunter.should_receive(:new).and_return hunter
      Evasion::Prey.should_receive(:new).and_return prey
      @game = Evasion::Game.new(:role => "HUNTER")
      @game.hunter.should == hunter
      @game.prey.should == prey
      @game.role.should == "HUNTER"
    end
  end
end
