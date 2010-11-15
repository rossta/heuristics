require 'spec_helper'

describe Evasion::Dispatch do
  before(:each) do
    @client = mock(Connection::Client,
      :connect => nil,
      :read => nil,
      :echo => nil,
      :disconnect => nil,
      :call => nil)
    Connection::Client.stub!(:new).and_return(@client)
    @dispatch = Evasion::Dispatch.new(:debug => true)
  end
  describe "initialize" do
    it "should create a client" do
      Connection::Client.should_receive(:new).with({
        :host => 'localhost',
        :port => 23000
      })
      Evasion::Dispatch.new(:debug => true)
    end
  end
  describe "start!" do
    
    describe "joining game" do
      it "should call client JOIN @name" do
        @dispatch.name = "Rossta"
        @client.should_receive(:call).with("JOIN Rossta")
        @dispatch.start!
      end
    end

    describe "response: ACCEPTED" do
      it "should create game with hunter on first response" do
        game = stub(Evasion::Game)
        @client.stub!(:read).once.and_return("ACCEPTED HUNTER")
        Evasion::Game.should_receive(:new).with(:role => :hunter).and_return(game)
        @dispatch.start!
        @dispatch.game.should == game
      end
      it "should create game on prey on first response" do
        @client.stub!(:read).once.and_return("ACCEPTED PREY")
        Evasion::Game.should_receive(:new).with(:role => :prey)
        @dispatch.start!
      end
    end

    describe "response: (xDimension, yDimension) wallCount, wallCooldown, preyCooldown" do
      it "should initialize game parameters" do
        @client.stub!(:read).once.and_return("(500, 500) 8, 50, 5")
        @dispatch.game = Evasion::Game.new
        @dispatch.start!
        @dispatch.game.width.should == 500
        @dispatch.game.height.should == 500
        @dispatch.game.wall_count.should == 8
        @dispatch.game.wall_cooldown.should == 50
        @dispatch.game.prey_cooldown.should == 5
      end
    end

    describe "response: YOURTURN..." do
      it "should set game state, no walls yet" do
        resp = "YOURTURN 1 H(100, 200, 1, NE), P(50, 75, 10), W[]"
        @client.stub!(:read).once.and_return(resp)
        game = stub(Evasion::Game, :turn= => nil, :update_hunter => nil, :update_prey => nil, :next_move => "PASS", :role => :prey)
        @dispatch.game = game
        game.should_receive(:update_walls).with(nil)
        @dispatch.start!
      end

      it "should set game state mid game" do
        # YOURTURN _ROUNDNUMBER_ H(x, y, cooldown, direction), P(x, y, cooldown), W[wall_one, wall_two]
        # (id, x1, y1, x2, y2)    : wall
        resp = "YOURTURN 1 H(100, 200, 1, NE), P(50, 75, 10), W[(1234, 300, 400, 300, 450)]"
        @client.stub!(:read).once.and_return(resp)
        game = stub(Evasion::Game, :next_move => "PASS", :role => :prey)
        @dispatch.game = game
        game.should_receive(:turn=).with(1)
        game.should_receive(:update_hunter).with(100, 200, 1, "NE")
        game.should_receive(:update_prey).with(50, 75, 10)
        game.should_receive(:update_walls).with([1234, 300, 400, 300, 450])
        @dispatch.start!
      end

      it "should set game state for more than one wall" do
        # YOURTURN _ROUNDNUMBER_ H(x, y, cooldown, direction), P(x, y, cooldown), W[wall_one, wall_two]
        # (id, x1, y1, x2, y2)    : wall
        resp = "YOURTURN 1 H(100, 200, 1, NE), P(50, 75, 10), W[(1234, 300, 400, 300, 450), (5678, 50, 100, 50, 200)]"
        @client.stub!(:read).once.and_return(resp)
        game = stub(Evasion::Game, :next_move => "PASS", :role => :prey)
        @dispatch.game = game
        game.should_receive(:turn=).with(1)
        game.should_receive(:update_hunter).with(100, 200, 1, "NE")
        game.should_receive(:update_prey).with(50, 75, 10)
        game.should_receive(:update_walls).with([1234, 300, 400, 300, 450], [5678, 50, 100, 50, 200])
        @dispatch.start!
      end
    end
  end

end
