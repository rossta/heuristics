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
      @game = Tipping::Game.new({
        :max_block    => 5,
        :range        => 5
      })
      @position = Tipping::Position.new(@game)
      @game.available_moves(@position, :player).size.should == 55
    end

    it "should return moves representing placing unused weights at each open location one at a time" do
      @game = Tipping::Game.new({
        :max_block  => 5,
        :range      => 5
      })
      @position = Tipping::Position.new(@game)
      @position[-4] = 3
      @position[1]  = @game.player.blocks.delete(1)
      @position[-1] = @game.opponent.blocks.delete(1)

      open_slots    = @position.open_slots.size
      unused_blocks = @game.player.blocks.size
      @game.available_moves(@position, :player).size.should == open_slots * unused_blocks
    end
  end

  describe "complete_move" do
    describe "player" do
      it "should update player's available blocks" do
        pending
      end

      it "should update game position" do
        pending
      end
    end

    describe "opponent" do
      it "should update oppponent's available blocks" do
        pending
      end

      it "should update game position" do
        pending
      end
    end

  end

end
