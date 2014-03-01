module Odds
  class CombinationParlay
    include FromHash
    fattr(:bets) { [] }

    fattr(:parlays) do
      bets.all_combinations.map do |bs|
        Parlay.new(:bets => bs)
      end
    end

    def winning_parlays(winning_bets)
      parlays.select do |parlay|
        parlay.bets.all? { |bet| winning_bets.include?(bet) }
      end
    end
  end
end