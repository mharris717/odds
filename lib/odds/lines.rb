module Odds
  class Lines
    include FromHash

    fattr(:bets) { [] }
    include Enumerable
    def each(&b)
      bets.each(&b)
    end

    def odds_sum
      bets.map { |x| x.odds }.sum
    end

    def to_fair
      to_vig(0.0)
    end

    def to_vig(target_vig)
      target_overround = target_vig / (1.0-target_vig)
      frac_overround =   (1.0+overround) / (1.0+target_overround) - 1.0
      frac_vig = frac_overround / (1.0 + frac_overround)

      res = map { |bet| bet.without_vig(frac_vig) }
      klass.new(bets: res)
    end

    def to_win_chance(target_win_chance)
      target_vig = (target_win_chance-1.0)/target_win_chance
      to_vig(target_vig)
    end

    def vig
      overround.to_f / (1.0 + overround.to_f)
    end

    def overround
      map { |x| x.odds }.sum.win_chance - 1.0
    end

    def to_s
      bets.join("\n")
    end

  end
end