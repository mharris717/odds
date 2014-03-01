load "lib/odds.rb"
include Odds

loaded = LoadSims.new

comb = CombinationParlay.new(:bets => loaded.bets)
parlays = comb.parlays
parlays.each do |parlay|
  parlay.wagered_amount = 0.001
end

utility = Algorithms::ParlayUtility.new(:scenarios => loaded.scenarios, :parlays => parlays)
puts utility.utility