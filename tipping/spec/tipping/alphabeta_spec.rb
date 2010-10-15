require File.dirname(__FILE__) + '/../spec_helper'

describe Tipping::AlphaBeta do

  def position_move(position)
    mock(Tipping::Move, :position => position)
  end

  before(:each) do
    Tipping::Move.stub!(:worst_move).and_return(Tipping::MIN_INT)
    Tipping::AlphaBeta.stub!(:find_alpha_beta_move).and_return(Proc.new { |move, depth, beta, local_alpha| 
      yield Tipping::AlphaBeta.move(move.position, depth - 1, -beta, -local_alpha)
    })
  end

  describe "self.move" do

    describe "min node" do
      it "should return lowest value of successors" do
        pending
        b = mock(Tipping::Position)
        c = mock(Tipping::Position)

        move_b = mock(Tipping::Move, :position => b, :score => 2)
        move_c = mock(Tipping::Move, :position => c)

        a = mock(Tipping::Position, :available_moves => [move_b, move_c])

        depth = 1

        Tipping::AlphaBeta.move(a, depth).should == -c.move
      end
    end

    describe "max node" do
      it "should return highest value of successors" do
        pending
        b = mock(Tipping::Position, :move => -2)
        c = mock(Tipping::Position, :move => -1)
        move_b = mock(Tipping::Move, :position => b)
        move_c = mock(Tipping::Move, :position => c)

        a = mock(Tipping::Position, :available_moves => [move_b, move_c])

        depth = 1

        Tipping::AlphaBeta.move(a, depth).should == -b.move
      end

      describe "four level tree" do
        # MAX           a
        # MIN   b                   c
        # MAX   d       e           f       g
        # MIN   h   i   j   k       l   m   n   o
        # vals  8   6   10          2   4

        before(:each) do
          positions = []
          15.times { positions << mock(Tipping::Position) }
          @a, @d, @e, @f, @g, @b, @c, @h, @i, @j, @k, @l, @m, @n, @o = positions

          moves = []
          positions.each { |p|
            moves << position_move(p)
          }
          @move_a, @move_d, @move_e, @move_f, @move_g, @move_b, @move_c, @move_h,
          @move_i, @move_j, @move_k, @move_l, @move_m, @move_n, @move_o = moves

          @a.stub!(:available_moves => [@move_b, @move_c])
          @b.stub!(:available_moves => [@move_d, @move_e])
          @c.stub!(:available_moves => [@move_f, @move_g])
          @d.stub!(:available_moves => [@move_h, @move_i])
          @e.stub!(:available_moves => [@move_j, @move_k])
          @f.stub!(:available_moves => [@move_l, @move_m])
          @g.stub!(:available_moves => [@move_n, @move_o])
          @h.stub!(:move => -8)
          @i.stub!(:move => -6)
          @j.stub!(:move => -10)
          @k.stub!(:move => -24)
          @l.stub!(:move => -2)
          @m.stub!(:move => -4)
          @n.stub!(:move => -19)
          @o.stub!(:move => -13)
        end

        describe "states" do
          it "should return 8 for d" do
            pending
            Tipping::AlphaBeta.move(@d, 1).should == 8
          end

          it "should return 8 for b" do
            pending
            Tipping::AlphaBeta.move(@b, 2).should == -8
          end

          it "should return 8 for b" do
            pending
            Tipping::AlphaBeta.move(@a, 3).should == 8
          end
        end
      end
    end

  end
end
