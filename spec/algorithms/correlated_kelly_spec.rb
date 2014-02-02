require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Correlated Kelly" do
  def bet(win_chance,odds_factor)
    odds_wc = win_chance / (1.0 + odds_factor)
    Odds::Bet.new(:win_chance => win_chance, :odds => odds_wc)
  end
  let(:bets) do
    res = []
    res << bet(0.3,-0.5)
    res << bet(0.2,0.3)
    res << bet(0.2,-0.1)
    res << bet(0.1,-0.4)
    res << bet(0.05,0.6)
    res << bet(0.05,0.2)
    res << bet(0.05,0)
    res << bet(0.03,-0.2)
    res << bet(0.02,0.8)
    res
  end

  let(:kelly) do
    Odds::Algorithms::CorrelatedKelly.new(bets)
  end

  it 'smoke' do
    kelly
    bets[1].wagered_amount.round(4).should == 0.0462
  end
end