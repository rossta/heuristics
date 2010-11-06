require 'spec_helper'

describe Voronoi::Game do
  before(:each) do
    @game = Voronoi::Game.new(400, 7, 2, 1)
  end
  describe "initialize" do
    it "should set moves, players, and player_id" do
      @game.size.should == 400
      @game.moves.should == 7
      @game.players.should == 2
      @game.player_id.should == 1
    end
    
    it "should set up the board" do
      board = @game.board 
      board.size.should == [400,400]
      board.players.should == 2
    end
  end
  
  describe "record_move" do
    it "should create move add to board" do
      move = stub(Voronoi::Move)
      Voronoi::Move.should_receive(:new).with(180, 182, 2).and_return(move)
      @game.board.should_receive(:add_move).with(move)
      @game.record_move(180, 182, 2)
    end
  end
  
  describe "find_and_record_next_move" do
    it "should return a move" do
      @game.find_and_record_next_move.should be_a(Voronoi::Move)
    end
    it "should return a move" do
      move = stub(Voronoi::Move)
      Voronoi::Move.should_receive(:new).and_return(move)
      @game.board.should_receive(:add_move).with(move)
      @game.find_and_record_next_move
    end
  end
end
