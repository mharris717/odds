require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Odds" do
  def self.should_have_to_s(win_chance,exp)
    it "to_s #{win_chance} -> #{exp}" do
      odds = Odds::Odds.new(:win_chance => win_chance)
      odds.to_s.should == exp
    end
  end

  def odds(win_chance)
    if win_chance.kind_of?(String)
      Odds::Odds.from_string(win_chance)
    else
      Odds::Odds.new(:win_chance => win_chance)
    end
  end

  should_have_to_s 0.25, '+300'
  should_have_to_s 0.75, '-300'
  should_have_to_s 0.4, '+150'
  should_have_to_s 0.6, '-150'
  should_have_to_s 0.5, '-100'

  it 'win_amount_with_principal' do
    odds(0.25).win_amount_with_principal.should == 4
  end

  it 'win_amount_with_principal' do
    odds(0.75).win_amount_with_principal.round(3).should == 1.333
  end

  it 'win_amount_with_principal' do
    odds(0.9).win_amount_with_principal.round(3).should == 1.111
  end

  it 'to_s_to_one' do
    odds(0.25).to_s_to_one.should == "3 to 1"
  end

  it 'to_s_to_one' do
    odds(0.75).to_s_to_one.should == "1 to 3"
  end

  it 'even to_s_to_one' do
    odds(0.5).to_s_to_one.should == '1 to 1'
  end

  it 'odds' do
    odds(0.25).odds.round(3).should == 0.333
  end

  describe 'math' do
    it 'multiply' do
      (odds(0.5) * odds(0.5)).win_chance.should == 0.25
    end

    it 'add' do
      (odds(0.2) + odds(0.1)).win_chance.round(6).should == 0.3
    end
  end

  it 'inverse' do
    odds(0.25).inverse.win_chance.should == 0.75
  end

  describe "other creation methods" do
    it 'from string' do
      odds("+300").win_chance.should == 0.25
    end

    it 'from string' do
      odds("-300").win_chance.should == 0.75
    end

    it 'from string bad' do
      lambda { odds("42") }.should raise_error
    end

    it 'from string even' do
      odds("+100").win_chance.should == 0.5
      odds("-100").win_chance.should == 0.5
    end

  end

  it 'to_odds - string' do
    "+150".to_odds.win_chance.should == 0.4
  end
end
