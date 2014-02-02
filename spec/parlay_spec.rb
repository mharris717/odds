require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Parlay" do
  describe 'basic' do
    let(:bets) do
      res = []
      res << Bet.new(:odds => "+200", :win_chance => 0.4)
      res << Bet.new(:odds => "+300", :win_chance => 0.3)
      res
    end
    let(:parlay) do
      Parlay.new(:bets => bets, :wagered_amount => 100)
    end

    it 'odds' do
      parlay.odds.win_chance.should == (1.0/12.0)
    end

    it 'win_chance' do
      parlay.win_chance.should == 0.12
    end

    it 'expected_profit' do
      parlay.expected_profit.round(4).should == 44
    end
  end

end