require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Kelly" do
  let(:bet) do
    Odds::Bet.new(:odds => "+200", :wagered_amount => 100, :win_chance => 0.4)
  end
  it 'basic' do
    bet.kelly.round(4).should == 0.1
  end

  it 'utility' do
    bet.log_utility_of_perc(0.1).round(5).should == 0.00971
  end
end