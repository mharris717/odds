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
    attr_accessor :odds, :wagered_amount, :win_chance

    def loss_chance
      1.0 - win_chance
    end

    def odds=(o)
      o = Odds.from_string(o) if o.kind_of?(String)
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
  end
end