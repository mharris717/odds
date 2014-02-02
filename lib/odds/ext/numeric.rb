class Numeric
  def abs_exp(e)
    if self > 0
      self**e
    else
      abs**e * -1
    end
  end

  def to_if
    if to_i == to_f
      to_i
    else
      to_f
    end
  end
end