require 'spec_helper'

describe Voronoi::Board do
  describe "initialize" do
    it "should have size, default of 400x400" do
      board = Voronoi::Board.new
      board.size.should == [400,400]

      board = Voronoi::Board.new(:size => [300, 300])
      board.size.should == [300,300]
    end

    it "should initialize empty moves for two players" do
      board = Voronoi::Board.new
      board.moves[1].should be_empty
      board.moves[2].should be_empty
      board.moves[3].should be_nil
    end

    it "should allow extra players if given" do
      board = Voronoi::Board.new(:players => 4)
      board.moves[1].should be_empty
      board.moves[2].should be_empty
      board.moves[3].should be_empty
      board.moves[4].should be_empty
      board.moves[5].should be_nil
    end

    it "should initialize 10000 scoring zones squares" do
      board = Voronoi::Board.new
      board.build_zones.size.should == 100 * 100
    end
    
    it "should build zones 4x4 with centers" do
      board = Voronoi::Board.new
      zone_1 = board.build_zones.first
      zone_1.x.should == 0
      zone_1.y.should == 0
      zone_1.center.should == [2,2]
      zone_1.width.should == 4
      zone_1.height.should == 4
    end
  end

  describe "add move" do
    before(:each) do
      @board = Voronoi::Board.new
    end
    it "should record given move for given player id" do
      # move given as x, y, id
      move_1 = Voronoi::Move.new(5,6,1)
      move_2 = Voronoi::Move.new(3,4,2)
      @board.add_move(move_1)
      @board.moves[1].should == [move_1]
      @board.moves[2].should == []

      @board.add_move(move_2)
      @board.moves[1].should == [move_1]
      @board.moves[2].should == [move_2]
    end

    it "should raise error if player not available" do
      move = Voronoi::Move.new(5,6,3)
      lambda { @board.add_move(move) }.should raise_error
    end
  end
  
  describe "moves" do
    before(:each) do
      @board = Voronoi::Board.new
    end
    describe "all_moves" do
      it "should return all recorded moves" do
        # move given as x, y, id
        move_1 = Voronoi::Move.new(5,6,1)
        move_2 = Voronoi::Move.new(3,4,2)
        @board.add_move(move_1)
        @board.add_move(move_2)
        @board.all_moves.size.should == 2
        @board.all_moves.should include(move_1)
        @board.all_moves.should include(move_2)
      end
    end
    describe "moves_by" do
      it "should return all recorded moves by given player id" do
        # move given as x, y, id
        move_1 = Voronoi::Move.new(5,6,1)
        move_2 = Voronoi::Move.new(3,4,2)
        @board.add_move(move_1)
        @board.add_move(move_2)
        @board.moves_by(1).size.should == 1
        @board.moves_by(1).should include(move_1)
        @board.moves_by(1).should_not include(move_2)
      end
    end
  end

  describe "score" do
    before(:each) do
      @board = Voronoi::Board.new
    end
    it "should return 0 if no moves for players" do
      @board.score(1).should == 0
      @board.score(2).should == 0
    end
    
    it "should return 100% of board for first players move, 0 for other" do
      move = Voronoi::Move.new(5,6,1)
      @board.add_move(move)
      @board.score(1).should == 1.0
      @board.score(2).should == 0
    end

    it "should return estimate of score for area held by given player" do
      move_1 = Voronoi::Move.new(10,10,1)
      move_2 = Voronoi::Move.new(390,390,2)
      @board.add_move(move_1)
      @board.add_move(move_2)
      # check correctness
      # pending
      @board.score(1).should be_within(0.05).of(0.5)
      @board.score(2).should be_within(0.05).of(0.5)
    end
    
    describe "given moves" do
      before(:each) do
        @first_move = Voronoi::Move.new(5,6,1)
        @board.add_move(@first_move)
      end
      it "should return 0 if given no moves" do
        @board.score(1, :moves => []).should == 0
      end
      it "should return 100% if given only player 1 moves" do
        @board.score(1, :moves => @board.all_moves + [Voronoi::Move.new(150,160,1)]).should == 1.0
      end
    end
  end
end
