require 'mharris_ext'

%w(to_odds string hash map_special numeric rand math object).each do |f|
  load File.dirname(__FILE__) + "/odds/ext/#{f}.rb"
end

%w(odds bet parlay lines).each do |f|
  load File.dirname(__FILE__) + "/odds/#{f}.rb"
end

%w(kelly correlated_kelly).each do |f|
  load File.dirname(__FILE__) + "/odds/algorithms/#{f}.rb"
end


