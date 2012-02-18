
require 'give4each/private_helpers'

class Give4Each::MethodChain

  HasArgs = Struct.new :method, :args, :block, :callback

  # for example,  
  #   Give4Eeach::MethodChain.new :any, *args, &block
  # as the:
  #   :any.with *args, &block
  def initialize method, *args, &block
    raise TypeError, "#{self.class} need to the symbol of the method." unless method.respond_to? :to_sym
    @current = HasArgs.new method.to_sym, args, block, method(:callback_of_normal)
    @callings = [@current]
  end

  # Examples::
  # *of_\**:
  #   :include: examples/of.rb
  # *and_\**:
  #   :include: examples/and.rb
  # You can do the same as +with+ if you pass the +args+.
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  def method_missing method, *args, &block
    case method.to_s
    when /^of_(.*)$/
      @current = HasArgs.new $1.to_sym, args, block, method(:callback_of_normal)
      @callings.unshift @current
    when /^and_(.*)$/
      @current = HasArgs.new $1.to_sym, args, block, method(:callback_of_normal)
      @callings.push @current
    else super
    end
    self
  end
  
  def callback_of_normal o, has
    o.send has.method, *has.args, &has.block
  end

  # example:
  #  :include: examples/with.rb
  def with *args, &block
    @current.args = args
    @current.block = block
    self
  end
  
  # *example*:
  #   a = []
  #   # => [] 
  #   (1..10).each &:push.to(a)
  #   # => 1..10 
  #   a
  #   # => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100] 
  def to *receivers
    @current.callback = lambda do |o, has|
      receivers.each &has.method.with(o, *has.args, &has.block); o
    end
    self
  end
  
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
    lambda do |o, *a, &b|
      @callings.inject o do |o, has|
        has.callback.call o, has
      end
    end
  end

end