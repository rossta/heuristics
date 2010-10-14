module Tipping

  class Player
    attr_accessor :blocks
    def initialize(max_block)
      @blocks = (1..max_block).to_a
    end
    
    def next_move(message)
      "#{rand(10)},#{rand(10)}"
    end
  end

end