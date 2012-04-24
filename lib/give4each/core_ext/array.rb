class Array
  
  def as_method
    proc { |*args| self[0].as_method.call(*(args + self[1..-1])) }
  end
  
  def as_setter
    proc { |*args| self[0].as_setter.call(*(args + self[1..-1])) }
  end
end