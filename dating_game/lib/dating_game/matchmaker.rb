module DatingGame

  class Matchmaker
    attr_accessor :attr_count, :candidates, :entropies

    def initialize
      @candidates = []
      @entropies  = []
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
      base_h  = []
      score_h = []
      info_g  = []
      incr_h  = []
      attrs   = []
      total   = candidates.size
      sorted  = candidates.sort { |c, d| d.score <=> c.score }
      best    = sorted.first
      wrst    = sorted.last
      mid_score = (best.score - wrst.score)/2 + wrst.score
      median  = sorted[sorted.size/2]
      attr_count.times do |j|
        best_j = best.attrs[j]
        wrst_j = wrst.attrs[j]
        diff_j = best_j - wrst_j
        mid_j  = (diff_j/2) + wrst_j
        
        prob_j = candidates.count { |c| c.attrs[j] > mid_j } / total.to_f
        cond_j = candidates.count { |c| c.attrs[j] > mid_j && c.score > mid_score } / total.to_f
        h_j    = prob_j - cond_j
        
        inc = rand((best_j * 100) * h_j).to_f/100
        if diff_j > 0
          attrs[j] = best_j + inc*(1 - best_j)
        else
          attrs[j] = best_j + inc*(0 - best_j)
        end
      end
      candidate = Candidate.new
      candidate.attrs = attrs
      candidates << candidate
      candidate
    end

    def prob_log2(prob)
      prob.zero? ? 0 : -prob*Math.log2(prob)
    end

  end

end