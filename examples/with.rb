require 'give4each'
# (1..5).map do |i|
#    i ** 2
# end
(1..5).map &:**.with(2) # => [1, 4, 9, 16, 25]
