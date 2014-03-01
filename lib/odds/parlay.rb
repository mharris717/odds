module Odds
  class Parlay
    include FromHash
    include Bet::ExpectedProfit
    attr_accessor :wagered_amount, :name
    fattr(:bets) { [] }

    fattr(:odds) do
      bets.map { |x| x.odds }.times_product
    end

    fattr(:win_chance) do
      bets.map { |x| x.win_chance }.times_product
    end

    def to_s
      name
    end
  end
end