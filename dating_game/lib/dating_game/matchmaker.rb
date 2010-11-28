module DatingGame

  class Matchmaker
    attr_accessor :attr_count

    def candidates
      @candidates ||= []
    end

    def parse_candidate(*args)
      score = args.shift
      candidate = Candidate.new
      candidate.score = score.to_f

      candidate.attrs = args.map(&:to_f)
      candidates << candidate
      candidate
    end
    
    def next_candidate
      @candidates[rand(@candidates.size)]
    end
  end

end