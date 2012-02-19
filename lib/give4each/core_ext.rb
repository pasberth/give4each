
class Symbol
  
  # :method: a
  # see also Give4Each::MethodChain#a

  # :method: an
  # see also Give4Each::MethodChain#an
  
  # :method: with
  # see also Give4Each::MethodChain#with

  # :method: in
  # see also Give4Each::MethodChain#in

  # :method: to
  # see also Give4Each::MethodChain#to

  # see also Give4Each::MethodChain#method_missing
  def method_missing f, *a, &b
    if  Give4Each.allowing_method? f
      Give4Each::MethodChain.new(self).send f, *a, &b
    else
      super
    end
  end
end
