class String
  def to_odds
    Odds::Odds.from_string(self)
  end
end