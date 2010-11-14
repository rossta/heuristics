require 'spec_helper'

describe Evasion::Game do
  before(:each) do
    @hunter = stub(Evasion::Hunter)
    @prey = stub(Evasion::Prey)
    Evasion::Hunter.stub!(:new).and_return @hunter
    Evasion::Prey.stub!(:new).and_return @prey
  end
  describe "initialize" do
    it "should create a players" do
      Evasion::Hunter.should_receive(:new).and_return @hunter
      Evasion::Prey.should_receive(:new).and_return @prey
      @game = Evasion::Game.new(:role => "HUNTER")
      @game.hunter.should == @hunter
      @game.prey.should   == @prey
      @game.role.should   == "HUNTER"
    end
  end
  
  describe "game state update" do
    before(:each) do
      @game = Evasion::Game.new
    end
    describe "turn=" do
      it "should set current turn" do
        subject.turn = 4
        subject.turn.should == 4
      end
    end
  
    describe "update_hunter" do
      it "should update hunter x, y, cooldown, and direction" do
        x = 100
        y = 200
        cooldown = 50
        direction = "SW"
        @hunter.should_receive(:update).with(x, y, cooldown, direction)
        @game.update_hunter(x, y, cooldown, direction)
      end
    end
    
    describe "update_prey" do
      it "should update prey x, y, cooldown" do
        x = 100
        y = 200
        cooldown = 20
        @prey.should_receive(:update).with(x, y, cooldown)
        @game.update_prey(100, 200, 20)
      end
    end
    
    describe "update_walls" do
      it "should create new walls" do
        wall_1 = stub(Evasion::Wall)
        Evasion::Wall.should_receive(:new).with(1234, 300, 400, 300, 450).and_return(wall_1)
        @game.update_walls([1234, 300, 400, 300, 450])
        @game.walls.should == [wall_1]
      end
      
      it "should have walls for each data set" do
        # (id, x1, y1, x2, y2)    : wall
        @game.update_walls([1234, 300, 400, 300, 500], [5678, 100, 200, 200, 200])
        @game.walls.size.should == 2
        wall_1 = @game.walls.first
        wall_2 = @game.walls.last
        
        wall_1.name.should == 1234
        wall_1.x_1.should == 300
        wall_1.y_1.should == 400
        wall_1.x_2.should == 300
        wall_1.y_2.should == 500

        wall_2.name.should == 5678
        wall_2.x_1.should == 100
        wall_2.y_1.should == 200
        wall_2.x_2.should == 200
        wall_2.x_2.should == 200
      end
    end
  end
end
