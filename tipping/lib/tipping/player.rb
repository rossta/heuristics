module Tipping

  class Player
    attr_accessor :blocks
    def initialize(max_block)
      @blocks = (1..max_block).to_a
    end
  end

end