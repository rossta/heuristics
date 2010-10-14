require 'spec_helper'

describe Tipping::Client do

  describe "initialize" do
    describe "defaults" do
      it "define host, port, timeout, logger, socket" do
        client = Tipping::Client.new
        client.host.should == "localhost"
        client.port.should == 4445
        client.timeout.should == 5
        client.sock.should be_nil
      end
    end
  end

  describe "connect" do
    before(:each) do
      @client = Tipping::Client.new(:host => 'localhost', :port => 1977)
      @socket = stub(TCPSocket)
      TCPSocket.stub!(:new).and_return(@socket)
    end

    it "should connect to host:port" do
      TCPSocket.should_receive(:new).with('localhost',1977).and_return(@socket)
      @client.connect
    end

    describe "connected?" do

      it "return true if socket" do
        @client.connect
        @client.connected?.should be_true
      end

      it "return false if no socket" do
        @client.connected?.should be_false
      end
    end
  end

  describe "server connection" do
    describe "ADD" do
      it "should respond to ADD first move" do
        pending
        begin
          client = Tipping::Client.new(:port => 4445)
          server = start_server(4445) do |s|
            client.connect
            s.send("Connected")
          end
          client.read.should =~ /Connected/
        ensure
          stop_server
        end
      end
    end
  end

  describe "format_add_remove" do
    it "should return [:add, { position }, { torques }]" do
      # in means right, out means left
      # message = "(ADD/REMOVE)|3,-4 4,-1 3,4 5,-2 6,0|in=25,out=-10"
      message   = "ADD|3,-4|in=-9.0,out=3.0"
      formatted = subject.send(:format_add_remove, message)
      formatted.should == ["ADD", {-4 => 3}, { :left => 3.0, :right => -9.0 }]

      message   = "REMOVE|3,-4 6,7|in=-10.0,out=-13.0"
      formatted = subject.send(:format_add_remove, message)
      formatted.should == ["REMOVE", {-4 => 3, 7 => 6}, { :left => -13.0, :right => -10.0 }]
    end
  end
end
