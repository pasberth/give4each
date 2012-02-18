class Symbol
  
  # Create new Give4Each::MethodChain with the Symbol and +args+ and +block+.
  # *example*:
  #   :include: examples/with.rb
  def with *args, &block
    Give4Each::MethodChain.new self, *args, &block
  end

  # Examples::
  # *of_\**:
  #   :include: examples/of.rb
  # *and_\**:
  #   :include: examples/and.rb
  def method_missing f, *a, &b
    if  Give4Each.allowing_method? f
      Give4Each::MethodChain.new(self).send f, *a, &b
    else
      super
    end
  end
end
