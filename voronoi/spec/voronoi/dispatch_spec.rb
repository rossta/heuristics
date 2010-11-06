require 'spec_helper'

describe Voronoi::Dispatch do
  before(:each) do
    @client = mock(Voronoi::Client, 
      :connect => nil, 
      :read => nil, 
      :echo => nil, 
      :disconnect => nil, 
      :call => nil)
    Voronoi::Client.stub!(:new).and_return(@client)
    @dispatch = Voronoi::Dispatch.new(:debug => true)    
  end
  describe "initialize" do
    it "should create a client" do
      Voronoi::Client.should_receive(:new).with({
        :host => 'localhost',
        :port => 44444
      })
      Voronoi::Dispatch.new(:debug => true)
    end
  end
  describe "start!" do
    
    describe "response: \d+ \d+ \d+" do
      it "should create game on first response" do
        @client.stub!(:read).once.and_return("400 7 2 1")
        game = stub(Voronoi::Game)
        Voronoi::Game.should_receive(:new).with(400, 7, 2, 1).and_return(game)
        @dispatch.start!
        @dispatch.game.should == game
      end
      it "should record move if game present" do
        @client.stub!(:read).once.and_return("123 234 2")
        @dispatch.game = stub(Voronoi::Game)
        @dispatch.game.should_receive(:record_move).with(123, 234, 2)
        @dispatch.start!
      end
    end

    describe "response: YOURTURN" do
      it "should respond with two numbers: x y" do
        
      end
    end
    
    describe "response: WIN/LOSE" do
      
    end
  end
end
