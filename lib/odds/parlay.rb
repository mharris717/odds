module Odds
  class Parlay
    include FromHash
    include Bet::ExpectedProfit
    attr_accessor :wagered_amount
    fattr(:bets) { [] }

    def odds
      bets.map { |x| x.odds }.times_product
    end

    def win_chance
      bets.map { |x| x.win_chance }.times_product
    end
  end
end