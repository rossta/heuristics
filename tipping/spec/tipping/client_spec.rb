require 'spec_helper'

describe Tipping::Client do

  describe "initialize" do
    describe "defaults" do
      it "define host, port, timeout, logger, socket" do
        client = Tipping::Client.new
        client.host.should == "127.0.0.1"
        client.port.should == 12345
        client.timeout.should == 5
        client.logger.should be_nil
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
        begin
          start_server
          response = "ADD|3,-4|in1=-6,out3=6"
          client = Tipping::Client.new
          client.connect
          client.message.should =~ /Connected/
        ensure
          stop_server
        end
      end
    end
  end

end
