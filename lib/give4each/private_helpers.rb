module Give4Each; end

module Give4Each::PrivateHelpers # :nodoc: all

  def allowing_method? f
    [:with, :a, :an, :the, :to, :in, :and, :of, :or, :for].include? f.to_sym or
    [/^of_.*$/, /^and_.*$/].any?(&:=~.with(f.to_s))
  end

end

module Give4Each
  include Give4Each::PrivateHelpers
  extend self
end