class Array
  def map_centered_on_sum(target_sum)
    self_sum = sum
    map { |x| x.to_f / self_sum.to_f * target_sum.to_f }
  end
  def map_restrict_to_range(r)
    map do |n|
      if n > r.end
        r.end
      elsif n < r.begin
        r.begin
      else
        n
      end
    end
  end
end