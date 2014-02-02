module Odds
  module Algorithms
    module CorrelatedKelly
      class Calc
        include FromHash
        attr_accessor :remaining
        fattr(:selected) { [] }

        def selected_set_rate
          if selected.empty?
            1.0
          else
            n = 1.0 - selected.map { |x| x.win_chance }.sum
            d = 1.0 - selected.map { |x| x.odds.win_chance }.sum
            n / d
          end
        end
        def set_rate
          selected_set_rate
        end

        def initialize(bets)
          self.remaining = bets.sort_by { |x| x.expected_profit }.reverse
        end

        def candidate
          remaining.first
        end

        def run!
          while candidate.expected_profit > set_rate
            prev_rate = set_rate
            self.selected << candidate
            self.remaining = remaining[1..-1]
            #puts "Adding #{selected.last.to_s}, rate #{prev_rate} -> #{set_rate}"
          end

          (selected+remaining).each do |bet|
            bet.wagered_amount = optimal_bet_perc(bet)
          end
        end

        def optimal_bet_perc(bet)
          res = bet.win_chance - (set_rate / bet.odds.win_amount_with_principal)
          [0,res].max
        end

        def to_s
          all = (selected + remaining)#.sort_by { |x| x.name[1..-1].to_i }
          all.map { |bet| "#{bet}: #{optimal_bet_perc(bet).to_s_perc}" }.join("\n")
        end
      end

      def self.new(*args)
        Calc.new(*args).tap { |x| x.run! }
      end
    end
  end
end