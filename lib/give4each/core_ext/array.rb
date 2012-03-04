class Array

  def method_missing f, *a, &b # :nodoc:
    if  Give4Each.allowing_method? f
      Give4Each::MethodChain.new(self).send f, *a, &b
    else
      super
    end
  end
  
  def to_proc
    lambda do |*a|
      map do |key|
        key.to_proc.call *a
      end
    end
  end
end