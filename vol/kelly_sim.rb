load "lib/odds.rb"

def kelly_sim(perc)
  bankroll = 0.000000001
  bet = Odds::Bet.new(:win_chance => 0.35, :odds => "+200")
  300000.times do
    bet.wagered_amount = bankroll.to_f*perc
    bankroll += bet.simulated_change
  end
  puts "Betting #{perc.to_s_perc.lpad(6)}: #{bankroll.to_i.to_s.length}"
end

(1..15).each do |i|
  perc = i.to_f * 0.005
  kelly_sim(perc)
end