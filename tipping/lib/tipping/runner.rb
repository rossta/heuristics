module Tipping

  class Runner
    include Utils::Timer

    attr_accessor :opts

    def self.run!(opts = {})
      runner = new(opts)
      runner.run!
    end

    def initialize(opts = {})
      @opts = opts
    end

    def run!
      time "Playing game ..." do
        @player = Player.new(opts)
        @player.play!
      end
    end

  end
end