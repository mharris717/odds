# U_ALL_HIT = PONLY(1,2,3) * log_p1(profit * weightings for all)
# U_AB_HIT = PONLY(a,b) * log_p1(Oab*Wab - WEIGHTOTHER(ab))
# U_A_HIT = PONLY(a) * log_p1(WEIGHTOTHER(nil)*-1)
# U_NONE_HIT = PONLY(nil) * log_p1(WEIGHTOTHER(nil)*-1)

module Odds
  module Algorithms
    class ParlayUtility

      class Scenario
        include FromHash
        attr_accessor :win_chance, :winners
      end

      include FromHash
      fattr(:parlays) { [] }
      fattr(:scenarios) { [] }

      def log_utility_for_scenario(scenario)
        winning_parlays = parlays.select { |parlay| parlay.bets.all? { |bet| scenario.winners.include?(bet) } }
        losing_parlays = parlays - winning_parlays

        winning_utility = winning_parlays.map do |parlay| 
          parlay.odds.win_amount_without_principal * parlay.wagered_amount
        end.sum || 0.0

        losing_utility = losing_parlays.map { |x| x.wagered_amount }.sum || 0.0

        scenario.win_chance * log_p1(winning_utility - losing_utility)
      end

      def utility
        scenarios.map { |x| log_utility_for_scenario(x) }.sum
      end

      def log_p1(num)
        Math.log(1.0+num)
      end
    end
  end
end




