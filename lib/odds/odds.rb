class Odds
  include FromHash
  attr_accessor :win_chance

  def initialize(arg)
    if arg.kind_of?(Hash)
      from_hash(arg)
    else
      self.win_chance = arg
    end
  end

  def to_s
    if win_chance < 0.5
      "+" + (win_amount_without_principal * 100.0).to_i.to_s
    else
      n = (1.0 / loss_chance) - 1.0
      "-" + (n * 100.0).to_i.to_s
    end
  end

  def to_s_to_one
    if win_chance < 0.5
      "#{win_amount_without_principal} to 1"
    else
      n = (1.0 / win_amount_without_principal).round(1)
      "1 to #{n}"
    end
  end

  def win_amount_with_principal
    1.0 / win_chance
  end
  def win_amount_without_principal
    win_amount_with_principal - 1.0
  end
  def loss_chance
    1.0 - win_chance
  end

  

  def* (other)
    res = win_chance * other.win_chance
    self.class.new(:win_chance => res)
  end

  def inverse
    self.class.new(:win_chance => (1.0 - win_chance))
  end

  def odds
    win_chance / (1.0 - win_chance)
  end

  def log_odds
    Math.log(odds)
  end

  class << self
    def from_string(str)
      sign = str[0..0]
      num = str[1..-1].to_f / 100.0
      if sign == '-'
        from_win_amount_without_principal(1.0 / num)
      elsif sign == '+'
        from_win_amount_without_principal(num)
      else
        raise "bad #{str}"
      end
    end
    def from_win_amount_without_principal(num)
      new(:win_chance => (1.0 / (1.0 + num)))
    end
  end
end