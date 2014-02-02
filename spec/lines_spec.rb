require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lines" do
  def bet(odds)
    Odds::Bet.new(:odds => odds)
  end
  let(:bets) do
    res = []
    res << bet("-150")
    res << bet("+200")
    res << bet("+300")
    Odds::Lines.new(:bets => res)
  end

  it 'smoke' do
    bets.odds_sum.win_chance.round(6).should == (0.6 + (1.0/3.0) + 0.25).round(6)
  end

  it 'fair' do
    bets.to_fair.map { |x| x.odds.win_chance }.sum.should == 1
  end

  it 'target vig' do
    target = 0.1/1.1
    bets.to_vig(target).map { |x| x.odds.win_chance }.sum.should == 1.1
  end

  it 'target vig - higher' do
    target = 0.4/1.4
    bets.to_vig(target).map { |x| x.odds.win_chance }.sum.round(6).should == 1.4
  end

  it 'target win_chance' do
    bets.to_win_chance(1.1).map { |x| x.odds.win_chance }.sum.should == 1.1
    
  end

end