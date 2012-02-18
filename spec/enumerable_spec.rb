require File.dirname(__FILE__) + '/spec_helper'

describe Range do
  
  it "can give arguments for each." do
    (1..5).map(&:**.with(2)).should == [1, 4, 9, 16, 25]
  end

end

describe Array do
  
  it "can chain methods." do
    %w[c++ lisp].map(&:capitalize.of_concat.with("er")).should == ["C++er", "Lisper"]
  end

end