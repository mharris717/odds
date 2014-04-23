class Numeric
  def to_s_perc(digits=2)
    return "nan" if to_s.downcase == 'nan'
    n = self.to_f * 100.0
    n.round(digits).to_s + "%"
  end
  def to_s_curr(digits=2)
    n = round(digits)
    sign = (n > 0) ? "" : "-"
    n = n.abs
    places = n.to_s.split(".").last.size
    n = n.to_s
    n << "0" if places == 1
    "#{sign}$#{n}"
  end
end

class NilClass
  def to_s_perc(*args)
    nil
  end
end