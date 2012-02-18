require 'give4each'

# %w[c++ lisp].map do |a|
#   a.concat("er").upcase
# end
%w[c++ lisp].map &:upcase.of_concat.with("er") # => ["C++ER", "LISPER"]
