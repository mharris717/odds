class Numeric
  def abs_exp(e)
    if self > 0
      self**e
    else
      abs**e * -1
    end
  end
end