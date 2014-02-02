require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Odds" do
  def self.should_have_to_s(win_chance,exp)
    it "to_s #{win_chance} -> #{exp}" do
      odds = Odds.new(:win_chance => win_chance)
      odds.to_s.should == exp
    end
  end

  def odds(win_chance)
    Odds.new(:win_chance => win_chance)
  end

  should_have_to_s 0.25, '+300'
  should_have_to_s 0.75, '-300'
  should_have_to_s 0.4, '+150'
  should_have_to_s 0.6, '-150'

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
    odds(0.25).to_s_to_one.should == "3.0 to 1"
  end

  it 'to_s_to_one' do
    odds(0.75).to_s_to_one.should == "1 to 3.0"
  end

  it 'odds' do
    odds(0.25).odds.round(3).should == 0.333
  end

  describe 'multiply' do
    it 'smoke' do
      (odds(0.5) * odds(0.5)).win_chance.should == 0.25
    end
  end

  it 'inverse' do
    odds(0.25).inverse.win_chance.should == 0.75
  end

  describe "other creation methods" do
    it 'from string' do
      Odds.from_string("+300").win_chance.should == 0.25
    end

    it 'from string' do
      Odds.from_string("-300").win_chance.should == 0.75
    end

    it 'from string bad' do
      lambda { Odds.from_string("42") }.should raise_error
    end
  end

  it 'to_odds - string' do
    "+150".to_odds.win_chance.should == 0.4
  end
end
