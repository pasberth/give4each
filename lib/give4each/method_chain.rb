
require 'give4each/private_helpers'

class Give4Each::MethodChain # :nodoc: all

  HasArgs = Struct.new :callable, :args, :block, :callback
  extend Give4Each::PrivateHelpers
  
  def self.natural callable, *args, &block
    callable = Give4Each.try_convert_into_callable! callable
    HasArgs.new callable.to_proc, args, block, lambda { |o, has| has.callable.call o, *has.args, &has.block }
  end

  def initialize *args, &callable_or_block
    if args.empty?
      callable = callable_or_block
      block = nil
    else
      callable = args.shift
      block = callable_or_block
    end
    @current = Give4Each::MethodChain.natural callable, *args, &block
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

  def of f, *args, &block
    @current = Give4Each::MethodChain.natural f, *args, &block
    @callings.unshift @current
    self
  end

  allow_symbol_method! :of

  def and f, *args, &block
    @current = Give4Each::MethodChain.natural f, *args, &block
    @callings.push @current
    self
  end
  
  allow_symbol_method! :and

  def or default_value
    old = @current.callback
    @current.callback = lambda do |o, has|
      old.call o, has or default_value
    end
    self
  end
  
  allow_symbol_method! :or

  def with *args, &block
    @current.args = args
    @current.block = block
    self
  end
  
  allow_symbol_method! :with
  
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

  def to *receivers
    @current.callback = lambda do |o, has|
      receivers.each do |receiver|
        has.callable.call receiver, o, *has.args, &has.block
      end
      o
    end
    self
  end
  
  allow_symbol_method! :to
  
  def in receiver
    @current.callback = lambda do |o, has|
      has.callable.call receiver, o, *has.args, &has.block
    end
    self
  end
  
  allow_symbol_method! :in
  
  def rescue return_value=nil
    old = @current.callback
    @current.callback = lambda do |o, has|
      old.call o, has rescue return_value
    end
    self
  end
  
  allow_symbol_method! :rescue

  def to_proc
    lambda do |o|
      @callings.inject o do |o, has|
        has.callback.call o, has
      end
    end
  end
end