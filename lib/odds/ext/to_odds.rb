class String
  def to_odds
    Odds.from_string(self)
  end
end