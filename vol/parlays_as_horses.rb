load "lib/odds.rb"
include Odds

class Sim
  include FromHash
  attr_accessor :bets
  
  def adj_factor
    1.1
  end

  fattr(:global_factor) do
    a = 1.0 - (adj_factor * 0.5)
    b = 1.0 + (adj_factor * 0.5)
    (a..b).rand_sq_num
  end
  fattr(:win_hash) do
    bets.inject({}) do |res,bet|
      num = rand * global_factor
      if true
        #nothing
      elsif num < 0
        num += 1
      elsif num > 1
        num -= 1
      end
      win = (num <= bet.win_chance)
      res.merge(bet.name => win)
    end
  end

  def bet_string
    res = []
    win_hash.each do |name,win|
      res << name if win
    end
    res.sort.join("-")
  end
end

class Sims
  include FromHash
  include Enumerable
  attr_accessor :bets
  fattr(:num_sims) { 1000000 }

  def new_sim
    Sim.new(:bets => bets)
  end

  fattr(:bet_string_hash) { Hash.new { |h,k| h[k] = 0 } }

  def add_to_parlay_comb_win_hash!(sims)
    sims.each do |sim|
      bet_string_hash[sim.bet_string] += 1
    end
  end

  def create!
    remaining = num_sims
    while remaining > 0
      sims = 10000.of { new_sim }
      add_to_parlay_comb_win_hash! sims
      remaining -= 10000
      puts "Left: #{remaining}"
    end
  end

  def parlay_for_bet_string(bet_string)
    if bet_string.blank? && false
      Parlay.new(:bets => [], :odds => ::Odds::Odds.new(:win_chance => 0.99), :win_chance => 0.0, :name => "None")
    else
      bet_names = bet_string.split("-")
      bets = bet_names.map { |x| single_bets[x] }
      other_bets = single_bets.values - bets

      all_odds = bets.map { |x| x.odds } + other_bets.map { |x| x.odds.inverse }
      Odds::Parlay.new(:bets => bets, :name => bet_string, :odds => all_odds.times_product)
    end
  end

  def simmed_parlays
    res = []
    bet_string_hash.each do |bet_string,num|
      parlay = parlay_for_bet_string(bet_string)
      parlay.win_chance = num.to_f / num_sims.to_f
      res << parlay
    end
    res
  end

  def write!
    require 'csv'
    CSV.open("sims.csv","w") do |csv|
      csv << bets.map { |x| x.name } + ["Count"]
      bet_string_hash.each do |bet_string,count|
        strs = bet_string.split("-")
        arr = []
        bets.each do |bet|
          if strs.include?(bet.name)
            arr << 1
          else
            arr << 0
          end
        end
        arr << count.to_f / num_sims.to_f
        csv << arr
      end
    end
  end
end

def make_single_bets
  res = []
  res << Bet.new(:name => "B4", :odds => 0.15, :win_chance => 0.15)
  res << Bet.new(:name => "B3", :odds => 0.25, :win_chance => 0.25)
  res << Bet.new(:name => "B2", :odds => 0.35, :win_chance => 0.35)
  res << Bet.new(:name => "B1", :odds => 0.45, :win_chance => 0.45)

  res.reverse
end

def single_bets
  $single_bets ||= make_single_bets.inject({}) { |s,i| s.merge(i.name => i) }
end

def sims
  $sims ||= begin
    res = Sims.new(:bets => single_bets.values)
    res.create!
    res
  end
end

def stuff

sims.simmed_parlays.sort_by { |x| x.win_chance }.reverse.each do |p|
  puts "#{p.name} #{p.win_chance.to_s_perc} #{p.odds}"
end

puts "\n\n"

corr = Odds::Algorithms::CorrelatedKelly.new(sims.simmed_parlays)
puts corr
end

sims.write!



