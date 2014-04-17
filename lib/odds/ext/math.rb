class Array
  def times_product
    inject { |s,i| s * i }
  end
  def sum
    inject { |s,i| s + i }
  end
end

class Array
  def all_combinations(r=nil)
    r ||= (2..count)
    r.inject([]) do |res,comb_size|
      res + combination(comb_size).to_a
    end
  end
end

class Hash
  def all_combinations(r=nil)
    res = []
    to_a.all_combinations(r).each do |comb|
      temp = {}
      comb.each do |kv|
        temp[kv[0]] = kv[1]
      end
      res << temp
    end
    res
  end
end

class Array
  def comb_one_from_each
    return self if self.size == 1
    raise "empty" if empty?

    res = []
    self[0].each do |el|
      rest_res = self[1..-1].comb_one_from_each
      rest_res.each do |rest_comb|
        res << [el]+rest_comb
      end
    end
    res
  end
end