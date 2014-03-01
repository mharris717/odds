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