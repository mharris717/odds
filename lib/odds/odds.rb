module Odds
  class Odds
    include FromHash
    attr_accessor :win_chance

    def win_chance=(w)
      @win_chance = w
    end

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
        "-" + (n * 100.0).round(4).to_i.to_s
      end
    end

    def to_s_to_one
      if win_chance < 0.5
        "#{win_amount_without_principal.to_if} to 1"
      else
        n = (1.0 / win_amount_without_principal).round(1)
        "1 to #{n.to_if}"
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
    def +(other)
      res = win_chance + other.win_chance
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

    def without_vig(vig)
      res = win_chance * (1.0-vig)
      self.class.new(win_chance: res)
    end

    def ==(x)
      win_chance == x.win_chance
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
      def from_win_amount_with_principal(num)
        from_win_amount_without_principal(num-1.0)
      end
      def from_decimal_odds(num)
        from_win_amount_with_principal(num)
      end

    end
  end
end