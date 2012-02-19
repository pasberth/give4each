
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
  #   :include: examples/of.rb
  # *and_\**:
  #   :include: examples/and.rb
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
  #  :include: examples/with.rb
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
  
  def in receiver
    @current.callback = lambda do |o, has|
      receiver.send has.method, o, *has.args, &has.block
    end
    self
  end
  
  def if &condition
    old = @current.callback
    @current.callback = lambda do |o, has|
      if condition.call o
        old.call o, has
      else
        o
      end
    end
    self
  end
  
  def unless &condition
    old = @current.callback
    @current.callback = lambda do |o, has|
      unless condition.call o then old.call o, has else o end
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