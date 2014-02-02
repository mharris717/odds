require 'mharris_ext'

%w(to_odds string hash map_special numeric rand math).each do |f|
  load File.dirname(__FILE__) + "/odds/ext/#{f}.rb"
end

%w(odds bet parlay).each do |f|
  load File.dirname(__FILE__) + "/odds/#{f}.rb"
end


