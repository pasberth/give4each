
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
      @current = natural $1, *args, &block
      @callings.unshift @current
      return self
    when /^and_(.*)$/
      @current =  natural $1, *args, &block
      @callings.push @current
      return self
    end

    return to_proc.send method, *args, &block if Proc.instance_methods.include? method

    super
  end
  
  def natural method, *args, &block
    HasArgs.new method.to_sym, args, block, lambda { |o, has| o.send has.method, *has.args, &has.block }
  end
  
  private :natural

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
  
  # *example*:
  #   receiver = "hello %s world"
  #   %w[ruby python].map &:%.in(receiver) # => ["hello ruby world", "hello python world"] 
  # *method chain*:
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
  
  def to_sym
    @method
  end

  def to_proc
    lambda do |o, &b|
      @callings.inject o do |o, has|
        has.callback.call o, has
      end
    end
  end

end