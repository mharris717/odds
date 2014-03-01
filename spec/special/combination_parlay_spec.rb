require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "CombinationParlay" do
  let(:comb) do
    Odds::CombinationParlay.new(:bets => bets)
  end

  let(:bets) do
    res = []
    res << Odds::Bet.new(:odds => "+200", :win_chance => 0.4)
    res << Odds::Bet.new(:odds => "+300", :win_chance => 0.3)
    res << Odds::Bet.new(:odds => "+400", :win_chance => 0.3)
    res << Odds::Bet.new(:odds => "+500", :win_chance => 0.3)
    res
  end

  it 'number of combinations' do
    comb.parlays.size.should == 11
  end

  it 'winning parlays' do
    comb.winning_parlays(bets[0..1]).tap do |w|
      w.size.should == 1
    end
  end

  it 'winning parlays' do
    comb.winning_parlays(bets[0..2]).tap do |w|
      w.size.should == 4
    end
  end
end