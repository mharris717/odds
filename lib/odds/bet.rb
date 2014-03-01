module Odds
  class Bet
    module ExpectedProfit
      def expected_profit
        n = (win_chance * odds.win_amount_with_principal) - 1.0
        n * wagered_amount.to_f
      end
    end

    include FromHash
    include ExpectedProfit
    attr_accessor :odds, :wagered_amount, :win_chance, :name

    def to_s
      "#{odds} #{wagered_amount.round(4)}"
    end

    def loss_chance
      1.0 - win_chance
    end

    def odds=(o)
      if o.kind_of?(String)
        o = Odds.from_string(o) 
      elsif o.kind_of?(Numeric)
        o = Odds.new(:win_chance => o)
      end
      @odds = o
    end

    def potential_profit
      odds.win_amount_without_principal * wagered_amount.to_f
    end

    def win_amount_with_principal
      odds.win_amount_with_principal * wagered_amount.to_f
    end

    def win_amount_without_principal
      odds.win_amount_without_principal * wagered_amount.to_f
    end

    def simulated_change
      if rand < win_chance
        wagered_amount.to_f * odds.win_amount_without_principal
      else
        -wagered_amount
      end
    end

    def without_vig(vig)
      res = clone
      res.odds = odds.without_vig(vig)
      res
    end
  end
end