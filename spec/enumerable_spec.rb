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
  
  it do
    a = []
    b = []
    c = []
    %w[hello world].each &:capitalize.and_push.to(a, b, c)
    a.should == %w[Hello World]
    b.should == %w[Hello World]
    c.should == %w[Hello World]
  end

  it do
    %w[e l o h].map(&:index.to("hello")).should == %w[e l o h]
  end
  
  it do
    %w[e l o h].map(&:index.in("hello")).should == [1, 2, 4, 0]
  end
  
end


