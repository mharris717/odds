module Odds
  module Algorithms
    module Kelly
      def kelly
        (odds.win_amount_without_principal*win_chance - loss_chance) / odds.win_amount_without_principal
      end

      def log_utility_of_perc(perc)
        remaining_perc = 1.0-perc
        
        loss_utility = Math.log(remaining_perc)*loss_chance
        win_utility = Math.log(1.0+(perc*odds.win_amount_without_principal.to_f))*win_chance

        loss_utility + win_utility
      end
    end
  end

  Bet.send :include, Algorithms::Kelly
end


