class Array
  def times_product
    inject { |s,i| s * i }
  end
end