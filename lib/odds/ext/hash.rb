class Hash
  def each_sorted_by_value_desc(&b)
    to_a.sort_by { |pair| pair[1] }.reverse.each { |pair| b[*pair] }
  end
end