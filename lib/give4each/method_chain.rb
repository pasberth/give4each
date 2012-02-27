
require 'give4each/private_helpers'

class Give4Each::MethodChain

  HasArgs = Struct.new :method, :args, :block, :callback

  # for example,  
  #   Give4Eeach::MethodChain.new :any, *args, &block
  # as the:
  #   :any.with *args, &block
  def initialize method, *args, &block
    raise TypeError, "#{self.class} need to the symbol of the method." unless method.respond_to? :to_sym
    @current = natural method, *args, &block
    @callings = [@current]
  end
  
  # Examples::
  # *of_\**:
  #   %w[c++ lisp].map &:upcase.of_concat.with("er") # => ["C++ER", "LISPER"]
  # *and_\**:
  #   %w[c++ lisp].map &:upcase.and_concat.with("er") # => ["C++er", "LISPer"]
  # You can do the same as +with+ if you pass the +args+.
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  def method_missing method, *args, &block
    case method.to_s
    when /^of_(.*)$/
      return self.of($1, *args, &block)
    when /^and_(.*)$/
      return self.and($1, *args, &block)
    end

    return to_proc.send method, *args, &block if Proc.instance_methods.include? method

    super
  end
  
  def respond_to? f
    super or Proc.instance_methods.include? f.to_sym
  end
  
  def natural method, *args, &block
    HasArgs.new method.to_sym, args, block, lambda { |o, has| o.send has.method, *has.args, &has.block }
  end
  
  private :natural
  
  # Wrong :(
  #   %w[c++ lisp].map &:upcase.of_+("er")
  # Right :)
  #   %w[c++ lisp].map &:upcase.of(:+, "er")
  def of method, *args, &block
    @current = natural method, *args, &block
    @callings.unshift @current
    self
  end
  
  # Wrong :(
  #   %w[c++ lisp].map &:upcase.of_+("er")
  # Right :)
  #   %w[c++ lisp].map &:upcase.of(:+, "er")
  def and method, *args, &block
    @current = natural method, *args, &block
    @callings.push @current
    return self
  end

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
  #
  def or default_value
    old = @current.callback
    @current.callback = lambda do |o, has|
      old.call o, has or default_value
    end
    self
  end

  # example:
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
  def with *args, &block
    @current.args = args
    @current.block = block
    self
  end
  
  alias a with
  alias an with
  alias the with
  
  # *example*:
  #   a = []
  #   # => [] 
  #   (1..10).each &:push.to(a)
  #   # => 1..10 
  #   a
  #   # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  def to *receivers
    @current.callback = lambda do |o, has|
      receivers.each &has.method.with(o, *has.args, &has.block); o
    end
    self
  end
  
  # Examples::
  # example:
  #   receiver = "hello %s world"
  #   %w[ruby python].map &:%.in(receiver) # => ["hello ruby world", "hello python world"] 
  # method chain:
  #   %w[ruby python].map &:%.in(receiver).and_upcase # => ["HELLO RUBY WORLD", "HELLO PYTHON WORLD"]
  # You should not use #to for that.
  #   receiver = "hello %s world"
  #   %w[ruby python].map &:%.to(receiver) # => ["ruby", "python"]
  def in receiver
    @current.callback = lambda do |o, has|
      receiver.send has.method, o, *has.args, &has.block
    end
    self
  end

  def to_proc
    lambda do |o|
      @callings.inject o do |o, has|
        has.callback.call o, has
      end
    end
  end

end