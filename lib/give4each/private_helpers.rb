module Give4Each; end

module Give4Each::PrivateHelpers # :nodoc: all

  def allowing_method? f
    [/^of_.*$/, /^and_.*$/].any? { |a| f.to_s =~ a } or
    [:with, :to, :in].include? f.to_sym
  end

end

module Give4Each
  include Give4Each::PrivateHelpers
  extend self
end