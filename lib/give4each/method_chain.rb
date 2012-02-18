
require 'give4each/private_helpers'

class Give4Each::MethodChain

  HasArgs = Struct.new :method, :args, :block

  # for example,  
  #   Give4Eeach::MethodChain.new :any, *args, &block
  # as the:
  #   :any.with *args, &block
  def initialize method, *args, &block
    raise TypeError, "#{self.class} need to the symbol of the method." unless method.respond_to? :to_sym
    @callings = [].push HasArgs.new method.to_sym, args, block
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
      @current = HasArgs.new $1, args, block
      @callings.unshift @current
    when /^and_(.*)$/
      @current = HasArgs.new $1, args, block
      @callings.push @current
    else super
    end
    self
  end

  # example:
  #  :include: examples/with.rb
  def with *args, &block
    @current.args = args
    @current.block = block
    self
  end
  
  def to_sym
    @method
  end

  def to_proc
    proc do |o, *a, &b|
      @callings.inject o do |o, has|
        o.send has.method, *has.args, &has.block
      end
    end
  end

end