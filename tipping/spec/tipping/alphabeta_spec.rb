require File.dirname(__FILE__) + '/../spec_helper'

describe Tipping::AlphaBeta do

  describe "self.score" do

    describe "min node" do
      it "should return lowest value of successors" do
        a = Tipping::GameState.min
        b = Tipping::GameState.max
        c = Tipping::GameState.max
        a.successors = [b, c]
        b.stub!(:score => 1)
        c.stub!(:score => 2)

        Tipping::AlphaBeta.score(a).should == 1
      end
    end

    describe "max node" do
      it "should return highest value of successors" do
        a = Tipping::GameState.max
        b = Tipping::GameState.min
        c = Tipping::GameState.min
        a.successors = [b, c]
        b.stub!(:score => 1)
        c.stub!(:score => 2)

        Tipping::AlphaBeta.score(a).should == 2
      end

      describe "four level tree" do
        # MAX           a
        # MIN   b                   c
        # MAX   d       e           f       g
        # MIN   h   i   j   k       l   m   n   o
        # vals  8   6   10          2   4
        
        before(:each) do
          maxes, mins = [], []
          5.times { maxes << Tipping::GameState.max }
          10.times { mins << Tipping::GameState.min }
          @a, @d, @e, @f, @g = maxes
          @b, @c, @h, @i, @j, @k, @l, @m, @n, @o = mins

          @a.successors = [@b, @c]

          @b.successors = [@d, @e]
          @c.successors = [@f, @g]
          @d.successors = [@h, @i]
          @e.successors = [@j, @k]
          @f.successors = [@l, @m]
          @g.successors = [@n, @o]
          @h.stub!(:score => 8)
          @i.stub!(:score => 6)
          @j.stub!(:score => 10)
          @k.stub!(:score => 24)
          @l.stub!(:score => 2)
          @m.stub!(:score => 4)
          @n.stub!(:score => 19)
          @o.stub!(:score => 13)
        end
        
        describe "states" do
          it "should return 8 for d" do
            Tipping::AlphaBeta.score(@d).should == 8
          end
          
          it "should return 8 for b" do
            Tipping::AlphaBeta.score(@b).should == 8
          end

          it "should return 8 for b" do
            Tipping::AlphaBeta.score(@a).should == 8
          end
        end
      end
    end

  end
end
