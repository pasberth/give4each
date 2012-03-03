module Give4Each; end

module Give4Each::PrivateHelpers # :nodoc: all
  
  ALLOWING_PATTERNS = []

  def allowing_method? f
    ALLOWING_PATTERNS.any? { |cond| cond.call f }
  end
    
  def try_convert_into_callable! callable_expected
    if callable_expected.respond_to? :call
      callable_expected
    elsif callable_expected.respond_to? :to_proc 
      callable_expected.to_proc
    elsif callable_expected.respond_to? :to_sym
      callable_expected.to_sym.to_proc
    else
      raise TypeError, "can't convert #{callable.class} into Proc." 
    end
  end
  
  private

    def allow_symbol_method! *fs, &cond
      fs << cond if block_given?
      fs.each do |f|
        ALLOWING_PATTERNS << lambda do |g|
          g = g.to_s
          case f
          when String, Symbol then f.to_s == g
          when Regexp then f === g
          when Proc then f.call(g)
          else
            false
          end
        end
      end
    end

    def define_symbol_method sym, &f
      define_method sym do |*args, &block|
        instance_exec args, block, &f
        self
      end
      allow_symbol_method! sym
      true
    end
end

module Give4Each
  include Give4Each::PrivateHelpers
  extend self
end