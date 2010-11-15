require 'spec_helper'

describe Evasion::Player do
  
  describe "to_coord" do
    it "should return [x,y]" do
      @player = Evasion::Player.new
      @player.update(100, 200, 50)
      @player.to_coord.should == [100, 200]
    end
  end
  
  describe Evasion::Hunter do
    describe "name" do
      it "should return :hunter" do
        subject.name.should == :hunter
      end
    end
    
    describe "next_coord" do
      before(:each) do
        @hunter = Evasion::Hunter.new
        @hunter.update(100, 200, 50, "NE")
      end
      it "should return [102, 202] if direction NE" do
        @hunter.direction = "NE"
        @hunter.next_coord.should == [102, 202]
      end
      it "should return [102, 198] if direction SE" do
        @hunter.direction = "SE"
        @hunter.next_coord.should == [102, 198]
      end
      it "should return [98, 198] if direction SW" do
        @hunter.direction = "SW"
        @hunter.next_coord.should == [98, 198]
      end
      it "should return [98, 202] if direction NW" do
        @hunter.direction = "NW"
        @hunter.next_coord.should == [98, 202]
      end
    end
    
    describe "moves" do
      it "should include directions and PASS" do
        subject.possible_moves.should include("ADD")
        subject.possible_moves.should include("REMOVE")
        subject.possible_moves.should include("PASS")
      end
    end
    
  end

  describe Evasion::Prey do
    describe "name" do
      it "should return :prey" do
        subject.name.should == :prey
      end
    end
    
    describe "moves" do
      it "should include directions and PASS" do
        subject.possible_moves.should include("NE")
        subject.possible_moves.should include("N")
        subject.possible_moves.should include("NW")
        subject.possible_moves.should include("S")
        subject.possible_moves.should include("SE")
        subject.possible_moves.should include("SW")
      end
    end
    describe "next_coord" do
      before(:each) do
        @prey = Evasion::Prey.new
        @prey.update(100, 200, 50)
      end
      it "should return [101, 201] if direction NE" do
        @prey.direction = "NE"
        @prey.next_coord.should == [101, 201]
      end
      it "should return [101, 199] if direction SE" do
        @prey.direction = "SE"
        @prey.next_coord.should == [101, 199]
      end
      it "should return [99, 199] if direction SW" do
        @prey.direction = "SW"
        @prey.next_coord.should == [99, 199]
      end
      it "should return [99, 201] if direction NW" do
        @prey.direction = "NW"
        @prey.next_coord.should == [99, 201]
      end
    end
  end
end
