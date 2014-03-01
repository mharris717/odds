module Odds
  class LoadSims
    fattr(:bets) do
      require 'csv'
      res = []
      CSV.foreach("input/bets.csv",:headers => true) do |row|
        res << Bet.new(:odds => row['Odds'].to_f, :name => row['Bet'])
      end
      res
    end

    fattr(:scenarios) do
      require 'csv'
      res = []
      CSV.foreach("input/sims.csv",:headers => true) do |row|
        winning_bets = bets.select { |bet| row[bet.name] == '1' }
        res << Algorithms::ParlayUtility::Scenario.new(:winners => winning_bets, :win_chance => row['Count'].to_f)
      end
      res
    end
  end
end