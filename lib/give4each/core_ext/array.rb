class Array
  
  def to_proc
    lambda do |o|
      map do |key|
        key.to_proc.call o
      end
    end
  end
end