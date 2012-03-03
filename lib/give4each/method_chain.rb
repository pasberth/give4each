
require 'give4each/private_helpers'

class Give4Each::MethodChain # :nodoc: all

  HasArgs = Struct.new :callable, :args, :block, :callback
  extend Give4Each::PrivateHelpers

  def initialize callable, *args, &block # :nodoc:
    @current = natural callable, *args, &block
    @callings = [@current]
  end
  
  def method_missing f, *args, &block
    case f.to_s
    when /^of_(.*)$/
      return self.of($1, *args, &block)
    when /^and_(.*)$/
      return self.and($1, *args, &block)
    end

    super
  end

  allow_symbol_method! /^of_(.*)$/, /^and_(.*)$/
  
  def natural callable, *args, &block
    if callable.respond_to? :call
      callable = callable
    elsif callable.respond_to? :to_proc 
      callable = callable.to_proc
    elsif callable.respond_to? :to_sym
      callable = callable.to_sym.to_proc
    else
      raise TypeError, "can't convert #{callable.class} into Proc." 
    end
    HasArgs.new callable.to_proc, args, block, lambda { |o, has| has.callable.call o, *has.args, &has.block }
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
      receivers.each do |receiver|
        has.callable.call receiver, o, *has.args, &has.block
      end
      o
    end
  end
  
  define_symbol_method :in do |args, block|
    raise ArgumentError, "wrong number of arguments (#{args.count} for 1)" if args.count != 1
    receiver = args[0]
    @current.callback = lambda do |o, has|
      has.callable.call receiver, o, *has.args, &has.block
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