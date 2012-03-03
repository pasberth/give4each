
require 'give4each/private_helpers'

class Give4Each::MethodChain # :nodoc: all

  HasArgs = Struct.new :method, :args, :block, :callback
  extend Give4Each::PrivateHelpers

  # for example,  
  #   Give4Eeach::MethodChain.new :any, *args, &block
  # as the:
  #   :any.with *args, &block
  def initialize method, *args, &block # :nodoc:
    @current = natural method, *args, &block
    @callings = [@current]
  end
  
  # Examples::
  # *of_\**:
  #   %w[c++ lisp].map &:upcase.of_concat("er") # => ["C++ER", "LISPER"]
  # *and_\**:
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  # You can do the same as +with+ if you pass the +args+.
  #   %w[c++ lisp].map &:upcase.and_concat("er") # => ["C++er", "LISPer"]
  def method_missing method, *args, &block
    case method.to_s
    when /^of_(.*)$/
      return self.of($1, *args, &block)
    when /^and_(.*)$/
      return self.and($1, *args, &block)
    end

    super
  end

  allow_symbol_method! /^of_(.*)$/, /^and_(.*)$/
  
  def natural method, *args, &block
    raise TypeError, "can't convert #{method.class} into Symbol." unless method.respond_to? :to_sym
    HasArgs.new method.to_sym, args, block, lambda { |o, has| o.send has.method, *has.args, &has.block }
  end
  
  private :natural
  
  def self.define_symbol_method sym, &f
    define_method sym do |*args, &block|
      instance_exec args, block, &f
      self
    end
    allow_symbol_method! sym
    true
  end
  
  private_class_method :define_symbol_method

  define_symbol_method :of do |args, block|
    raise ArgumentError, "wrong number of arguments (#{args.count} for 1..)" if args.count < 1
    @current = natural *args, &block
    @callings.unshift @current
  end

  define_symbol_method :and do |args, block|
    raise ArgumentError, "wrong number of arguments (#{args.count} for 1..)" if args.count < 1
    @current = natural *args, &block
    @callings.push @current
  end

  define_symbol_method :or do |args, block|
    raise ArgumentError, "wrong number of arguments (#{args.count} for 1)" if args.count != 1
    default_value = args[0]
    old = @current.callback
    @current.callback = lambda do |o, has|
      old.call o, has or default_value
    end
  end

  define_symbol_method :with do |args, block|
    @current.args = args
    @current.block = block
  end
  
  alias a with
  alias an with
  alias the with
  allow_symbol_method! :a, :an, :the
  
  if RUBY_VERSION >= "1.9"
    alias call with
    allow_symbol_method! :call
  else
    alias [] with
    allow_symbol_method! :[]
  end

  define_symbol_method :to do |receivers, block|
    @current.callback = lambda do |o, has|
      receivers.each &has.method.with(o, *has.args, &has.block); o
    end
  end
  
  define_symbol_method :in do |args, block|
    raise ArgumentError, "wrong number of arguments (#{args.count} for 1)" if args.count != 1
    receiver = args[0]
    @current.callback = lambda do |o, has|
      receiver.send has.method, o, *has.args, &has.block
    end
  end
  
  def to_proc
    lambda do |o|
      @callings.inject o do |o, has|
        has.callback.call o, has
      end
    end
  end
end