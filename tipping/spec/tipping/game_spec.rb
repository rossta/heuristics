require 'spec_helper'

describe Tipping::Game do

  describe "score" do
    before(:each) do
      @game     = Tipping::Game.new
      @position = Tipping::Position.new
      @position.prepare!
    end
    describe "conservative" do
      describe "player" do
        # basic formula:
        # score = (weight + distance from left support) + (weight + distance from right support)

        it "should return high score based for large weight close to support" do
          @position[@game.left_support] = 10
          @game.score(@position, :player).should == (10 * (0 + 2)) + (3 * (1 + 3))
        end

        it "should return not as high score for small weight close support" do
          @position[@game.right_support] = 1
          @game.score(@position, :player).should == (1 * (0 + 2)) + (3 * (1 + 3))
        end

        it "should return negative score if tip left" do
          @position[-10] = 10
          @game.score(@position, :player).should == -1
        end

        it "should return negative score if tip right" do
          @position[10] = 10
          @game.score(@position, :player).should == -1
        end
      end
      describe "player" do
        # basic formula:
        # score = (weight + distance from left support) + (weight + distance from right support)

        it "should return neg high score based for large weight close to support" do
          @position[@game.left_support] = 10
          @game.score(@position, :opponent).should == -((10 * (0 + 2)) + (3 * (1 + 3)))
        end

        it "should return neg not as high score for small weight close support" do
          @position[@game.right_support] = 1
          @game.score(@position, :opponent).should == - ((1 * (0 + 2)) + (3 * (1 + 3)))
        end

        it "should return positive score if tip left" do
          @position[-10] = 10
          @game.score(@position, :opponent).should == 1
        end

        it "should return positive score if tip right" do
          @position[10] = 10
          @game.score(@position, :opponent).should == 1
        end
      end
    end

    describe "red strategy: going first" do
      it "should force bad endgame for blue" do
        pending
      end
    end

    describe "blue strategy: going last" do
      it "should prevent bad endgame" do
        pending
      end
    end
  end

  describe "defaults" do
    it "should have range 15" do
      subject.range.should == 15
    end
    it "should have locations -15 to 15" do
      subject.locations.size.should == 31
      subject.locations.first.should == -15
      subject.locations.last.should == 15
    end
    it "should have weight 3" do
      subject.weight.should == 3
    end
    it "should have supports at positions -3 and -1" do
      subject.left_support.should   == -3
      subject.right_support.should  == -1
    end
  end

  describe "available_moves" do
    it "should return moves for open locations and unused weights" do
      @game = Tipping::Game.new
      @game.update_position({-4 => 3})
      @game.available_moves(:player).size.should == 300
    end
    
    describe "nested moved" do
      before(:each) do
        @game = Tipping::Game.new
        @game.update_position({-4 => 3})
        @move_1 = Tipping::Move.new(5, 0, Tipping::PLAYER)
        @move_2 = Tipping::Move.new(4, 1, Tipping::OPPONENT)
      end
      it "should return moves representing placing unused weights at each open location one at a time" do
        @game.do_move(@move_1)
        @game.player.blocks.should == [1,2,3,4,6,7,8,9,10]
        @game.opponent.blocks.should == [1,2,3,4,5,6,7,8,9,10]
        @game.position.open_slots.size.should == 29
        @game.position.open_slots.should == (-15..-5).to_a + (-3..-1).to_a + (1..15).to_a
        @game.available_moves(:player).size.should == 261
        @game.available_moves(:opponent).size.should == 290
      end
      it "should return moves representing placing unused weights at each open location one at a time" do
        @game.do_move(@move_1)
        @game.do_move(@move_2)
        @game.player.blocks.should    == [1,2,3,4,6,7,8,9,10]
        @game.opponent.blocks.should  == [1,2,3,5,6,7,8,9,10]
        @game.position.open_slots.size.should == 28
        @game.position.open_slots.should == (-15..-5).to_a + (-3..-1).to_a + (2..15).to_a
        @game.available_moves(:player).size.should    == 252
        @game.available_moves(:opponent).size.should  == 252
        
        @game.undo_move(@move_2)
        @game.player.blocks.should == [1,2,3,4,6,7,8,9,10]
        @game.opponent.blocks.should == [1,2,3,4,5,6,7,8,9,10]
        @game.position.open_slots.size.should == 29
        @game.position.open_slots.should == (-15..-5).to_a + (-3..-1).to_a + (1..15).to_a
        @game.available_moves(:player).size.should == 261
        @game.available_moves(:opponent).size.should == 290
      end
    end
  end

end
