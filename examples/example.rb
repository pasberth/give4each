begin
  require 'give4each'
rescue LoadError
  require './' + File.dirname(__FILE__) + '/../lib/give4each'
end

# (1..5).map do |i|
#   i ** 2
# end
p (1..5).map &:**.with(2) # => [1, 4, 9, 16, 25]
  
# %w[c++ lisp].map do |a|
#   a.concat("er").upcase
# end
p %w[c++ lisp].map &:upcase.of_concat.with("er") # => ["C++ER", "LISPER"]

# %w[c++ lisp].map do |a|
#   a.upcase.concat("er")
# end
p %w[c++ lisp].map &:upcase.and_concat.with("er") # => ["C++er", "LISPer"]