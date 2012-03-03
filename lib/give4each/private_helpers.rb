module Give4Each; end

module Give4Each::PrivateHelpers # :nodoc: all

  def allowing_method? f
    [:with, :a, :an, :the, :to, :in, :and, :of, :or].include? f.to_sym or
    [/^of_.*$/, /^and_.*$/].any?(&:=~.with(f.to_s)) or
    (RUBY_VERSION >= "1.9" and [:call].include? f.to_sym)
  end

end

module Give4Each
  include Give4Each::PrivateHelpers
  extend self
end