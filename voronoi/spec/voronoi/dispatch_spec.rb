require 'spec_helper'

describe Voronoi::Dispatch do
  before(:each) do
    Voronoi::Dispatch.debug = true
    @client = mock(Voronoi::Client, :connect => nil, :read => nil, :echo => nil, :call => nil)
    Voronoi::Client.stub!(:new).and_return(@client)
  end
  after(:each) do
    Voronoi::Dispatch.debug = false
  end
  describe "initialize" do
    it "should create a client" do
      Voronoi::Client.should_receive(:new).with({
        :host => 'localhost',
        :port => 44444
      })
      Voronoi::Dispatch.new
    end
  end
  describe "start!" do
    
    describe "response format: \d+ \d+ \d+" do
      it "should create game on first response" do
        @client.stub!(:read).once.and_return("7 2 1")
        game = stub(Voronoi::Game)
        Voronoi::Game.should_receive(:new).with(7, 2, 1).and_return(game)
        subject.start!
        subject.game.should == game
      end
      it "should record move if game present" do
        @client.stub!(:read).once.and_return("123 234 2")
        subject.game = stub(Voronoi::Game)
        subject.game.should_receive(:record_move).with(123, 234, 2)
        subject.start!
      end
    end
  end
end
