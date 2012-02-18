require 'gvie4each'
# %w[c++ lisp].map do |a|
#   a.upcase.concat("er")
# end
%w[c++ lisp].map &:upcase.and_concat.with("er") # => ["C++er", "LISPer"]
