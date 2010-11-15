require 'spec_helper'

describe Evasion::Game do
  describe "initialize" do
    before(:each) do
      @hunter = stub(Evasion::Hunter, :name => :hunter)
      @prey = stub(Evasion::Prey, :name => :prey)
      Evasion::Hunter.stub!(:new).and_return @hunter
      Evasion::Prey.stub!(:new).and_return @prey
    end
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
        @hunter = stub(Evasion::Hunter, :name => :hunter)
        @prey = stub(Evasion::Prey, :name => :prey)
        Evasion::Hunter.stub!(:new).and_return @hunter
        Evasion::Prey.stub!(:new).and_return @prey
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
      it "should set empty array if no data" do
        @game.update_walls
        @game.walls.should == []
      end

      it "should update empty wall set" do
        @game.update_walls
        @game.walls.should == []

        @game.update_walls nil
        @game.walls.should == []
      end

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

  describe "player_at_depth" do
    before(:each) do
      @game = Evasion::Game.new
    end
    describe "hunter role" do
      before(:each) do
        @game.role = Evasion::HUNTER
      end
      it "should be hunter for game role at even depth" do
        @game.player_at_depth(2).should == @game.hunter
      end
      it "should be prey for odd depth" do
        @game.player_at_depth(1).should == @game.prey
      end
    end
  end

  describe "outer_walls" do
    it "should return four walls for width and height" do
      subject.outer.size.should == 4
    end
  end

  describe "available_moves" do
    before(:each) do
      @game = Evasion::Game.new
      @game.wall_count = 6
    end
    # describe "player" do
    #   it "should return add largest wall, pass" do
    #     @game.available_moves(@game.hunter).size.should == 2
    #   end
    # end

    describe "prey" do
      it "should return directions" do
        @game.role = Evasion::PREY
        @game.available_moves(@game.prey).size.should == 8
        pos = Evasion::Position.new(@game.hunter.clone, @game.prey.clone)
        @game.alpha_beta(pos, 8).last.should == "SE"
      end
    end
  end

end

describe Evasion::Position do
  before(:each) do
    @hunter = Evasion::Hunter.new
    @prey = Evasion::Prey.new
    @position = Evasion::Position.new(@hunter, @prey)
    @hunter.update(100, 100, 50, "NE")
    @prey.update(200, 200, 50)
  end
  describe "score" do
    it "should favor hunter if both moving towards" do
      @hunter.direction = "NE"
      @prey.direction   = "SW"
      @position.score(@hunter).should > 0
      @position.score(@prey).should < 0
    end
    it "should favor hunter if direction away" do
      @hunter.direction = "NE"
      @prey.direction   = "NE"
      @position.score(@hunter).should > 0
      @position.score(@prey).should < 0
    end
    it "should favor prey if opposite parallel" do
      @hunter.direction = "NW"
      @prey.direction   = "SE"
      @position.score(@hunter).should < 0
      @position.score(@prey).should > 0
    end
    it "should favor prey if same parallel" do
      @hunter.direction = "NW"
      @prey.direction   = "NW"
      @position.score(@hunter).should < 0
      @position.score(@prey).should > 0
    end
    it "should favor prey if hunter moving away" do
      @hunter.direction = "SW"
      @prey.direction   = "NE"
      @position.score(@hunter).should < 0
      @position.score(@prey).should > 0
    end
  end

  describe "best_wall" do
    before(:each) do
      @game = Evasion::Game.new
    end

    it "should return a wall" do
      @game.update_hunter(25, 25, 0, "NE")

      best_wall = @game.best_wall
      best_wall.should be_a(Evasion::Wall)

      best_wall.name.should == "1"
      best_wall.x_1.should == 1
      best_wall.y_1.should == 201
      best_wall.x_2.should == 499
      best_wall.y_2.should == 201

      @game.walls << best_wall

      best_wall_2 = @game.best_wall
      best_wall_2.should be_a(Evasion::Wall)

      best_wall_2.name.should == "2"
      
      best_wall_2.x_1.should == 331
      best_wall_2.y_1.should == 1
      best_wall_2.x_2.should == 331
      best_wall_2.y_2.should == 200

      @game.walls << best_wall_2

      @game.update_hunter(100, 100, 0, "NE")
      
      best_wall_3 = @game.best_wall
      best_wall_3.should be_a(Evasion::Wall)

      best_wall_3.name.should == "3"
      
      best_wall_3.x_1.should == 1
      best_wall_3.y_1.should == 99
      best_wall_3.x_2.should == 330
      best_wall_3.y_2.should == 99

      @game.walls << best_wall_3

      best_wall_4 = @game.best_wall
      best_wall_4.should be_a(Evasion::Wall)
                
      best_wall_4.name.should == "4"
                
      best_wall_4.x_1.should == 99
      best_wall_4.y_1.should == 100
      best_wall_4.x_2.should == 99
      best_wall_4.y_2.should == 200
    end

  end
end
