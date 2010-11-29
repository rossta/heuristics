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
      total = candidates.size
      sorted = candidates.sort { |d, c| c.score <=> d.score }
      best = sorted.first
      median = sorted[sorted.size/2]
      attr_count.times do |j|
        aboves    = candidates.select { |c| c.attrs[j] > median.attrs[j] }

        prob_above = aboves.size.to_f / total
        base_h[j] = candidates.map { |c| c.attrs[j] }.map { |v| v > median.atts[j] ? prob_above*Math.log2(prob_above) : (1) }

        betters = candidates.select { |c| c.attrs[j] > median.attrs[j] && c.score > median.score }
        prob_better = betters.size.to_f / total
        incr_h[j] = prob_log2(prob_better) + prob_log2(1-prob_better)
        info_g[j] = ((base_h[j] - incr_h[j]) * 100).to_i / 100.to_f
      end
      puts base_h.join ' '
      puts incr_h.join ' '
      puts info_g.join ' '
      info_g.each_with_index do |g, i|
        attrs[i] = best.attrs[i] + (g * (best.attrs[i] - median.attrs[i]))
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