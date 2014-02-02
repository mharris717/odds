class Numeric
  def to_s_perc(digits=2)
    n = self.to_f * 100.0
    n.round(digits).to_s + "%"
  end
end