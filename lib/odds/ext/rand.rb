class Range
  def rand_num
    num = rand * (self.end.to_f - self.begin.to_f)
    num + self.begin.to_f
  end

  def rand_sq_num
    a = self.begin**2
    b = self.end**2
    num = (a..b).rand_num
    num.to_f**0.5
  end

  def rand_sqrt_num
    a = self.begin.to_f**0.5
    b = self.end.to_f**0.5
    num = (a..b).rand_num
    num.to_f**2
  end
end

class Array
  def rand_el
    i = (rand()*size.to_f).to_i
    self[i]
  end
end