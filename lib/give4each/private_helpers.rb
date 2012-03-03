module Give4Each; end

module Give4Each::PrivateHelpers # :nodoc: all
  
  ALLOWING_PATTERNS = []

  def allowing_method? f
    ALLOWING_PATTERNS.any? { |cond| cond.call f }
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
end

module Give4Each
  include Give4Each::PrivateHelpers
  extend self
end