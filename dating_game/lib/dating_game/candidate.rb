module DatingGame
  class Candidate
    attr_accessor :score
    attr_writer :attrs

    def to_msg
      attrs.join(DELIM)
    end

    def attrs
      @attrs ||= []
    end
  end
end