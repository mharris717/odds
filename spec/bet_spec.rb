require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bet" do
  Bet = Odds::Bet
  it 'smoke' do
    bet = Bet.new(:odds => "+200", :wagered_amount => 100)
    bet.potential_profit.should == 200
  end

  it 'smoke' do
    bet = Bet.new(:odds => "-200", :wagered_amount => 100)
    bet.potential_profit.should == 50
  end

  it 'ev' do
    bet = Bet.new(:odds => "+200", :wagered_amount => 100, :win_chance => 0.4)
    bet.expected_profit.round(4).should == 20
  end
end