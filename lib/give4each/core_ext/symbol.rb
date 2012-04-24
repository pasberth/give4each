require 'give4each'

class Symbol

  # ========================================
  # :method: of
  # :call-seq:
  #   of(method, *args, &block)
  #
  # Wrong :(
  #   %w[c++ lisp].map &:upcase.of_+("er")
  # Right :)
  #   %w[c++ lisp].map &:upcase.of(:+, "er")
  # ========================================

  # ========================================
  # :method: and
  # :call-seq:
  #   and(method, *args, &block)
  #
  # Wrong :(
  #   %w[c++ lisp].map &:upcase.of_+("er")
  # Right :)
  #   %w[c++ lisp].map &:upcase.of(:+, "er")
  # ========================================

  # ========================================
  # :method: or
  # :call-seq:
  #   or(default_value)
  #
  # For example, I expect the nil is replaced by 0:
  #
  #    [
  #      [1, 2],
  #      [3],
  #      []
  #    ].map &:first # => [1, 3, nil]
  #
  # But this is needlessly long!:
  #
  #   [
  #     [1, 2],
  #     [3],
  #     []
  #   ].map { |a| a.first or 0 } # => [1, 3, 0]
  #
  # I think I write:
  #
  #   [
  #     [1, 2],
  #     [3],
  #     []
  #   ].map &:first.or(0) # => [1, 3, 0]
  # ========================================
  
  # ========================================
  # :method: with
  # :call-seq:
  #    with(*args, &block)
  #
  # *example*:
  #   # (1..5).map do |i|
  #   #   i ** 2
  #   # end
  #   p (1..5).map &:**.with(2) # => [1, 4, 9, 16, 25]
  #
  #   # %w[c++ lisp].map do |a|
  #   #   a.concat("er").upcase
  #   # end
  #   p %w[c++ lisp].map &:upcase.of_concat.with("er") # => ["C++ER", "LISPER"]
  #
  #   # %w[c++ lisp].map do |a|
  #   #   a.upcase.concat("er")
  #   # end
  #   p %w[c++ lisp].map &:upcase.and_concat.with("er") # => ["C++er", "LISPer"]
  #
  # the 'a', 'an', and 'the' are aliases for this.
  #
  # This is strange in English, is not you?
  #
  #   char = 'l'
  #   %w[hello world].map &:count.with(char) # => [2, 1]
  #
  # If you want to use, let's choose what you like.
  #
  #   %w[hello world].map &:count.a(char)
  #   %w[hello world].map &:count.the('l')
  # ========================================

  # ========================================
  # :method: to
  # :call-seq:
  #  to(*receivers)
  #
  # *example*:
  #   a = []
  #   # => [] 
  #   (1..10).each &:push.to(a)
  #   # => 1..10 
  #   a
  #   # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # ========================================

  # ========================================
  # :method: in
  # :call-seq:
  #   in(receiver)
  #
  # *example*:
  #   receiver = "hello %s world"
  #   %w[ruby python].map &:%.in(receiver) # => ["hello ruby world", "hello python world"] 
  #
  # *method chain*:
  #   %w[ruby python].map &:%.in(receiver).and_upcase # => ["HELLO RUBY WORLD", "HELLO PYTHON WORLD"]
  #
  # You should not use #to for that.
  #   receiver = "hello %s world"
  #   %w[ruby python].map &:%.to(receiver) # => ["ruby", "python"]
  # ========================================

  # Examples::
  # *of_\**:
  #   %w[c++ lisp].map &:upcase.of_concat("er") # => ["C++ER", "LISPER"]
  # *and_\**:
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  # You can do the same as +with+ if you pass the +args+.
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  def method_missing f, *a, &b # :nodoc:
    if  Give4Each.allowing_method? f
      Give4Each::MethodChain.new(self).send f, *a, &b
    else
      super
    end
  end
  
  alias as_method to_proc
  
  def as_setter
    proc { |o, *args| o.send(:"#{self}=", *args) }
  end
end
