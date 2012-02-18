require File.dirname(__FILE__) + '/spec_helper'

describe Range do
  
  it "can give arguments for each." do
    (1..5).map(&:**.with(2)).should == [1, 4, 9, 16, 25]
  end
  
end

describe Array do
  
  it do
    # %w[c++ lisp].map { |l| l.concat("er").upcase }
    %w[c++ lisp].map(&:upcase.of_concat.with("er")).should == %w[C++ER LISPER]
  end

  it do
    %w[c++ lisp].map(&:upcase.of_concat("er")).should == %w[C++ER LISPER]
  end

  it do
    # %w[c++ lisp].map { |l| l.upcase.concat("er") }
    %w[c++ lisp].map(&:upcase.and_concat.with("er")).should == %w[C++er LISPer]
  end

  it do
    %w[c++ lisp].map(&:upcase.and_concat("er")).should == %w[C++er LISPer]
  end
  
  it do
    # a, b, c = [], [], []
    # %w[hello world].each { |s| [a, b, c].each { |q| q << s.capitalize } 
    a, b, c = [], [], []
    %w[hello world].each &:capitalize.and_push.to(a, b, c)
    a.should == %w[Hello World]
    b.should == %w[Hello World]
    c.should == %w[Hello World]
  end

  it do
    # a = []
    # %w[hello world].map { |s| a.push s; s.capitalize }
    a = []
    %w[hello world].map(&:capitalize.of_push.to(a)).should == %w[Hello World]
    a.should == %w[hello world]
  end

  it do
    # %w[e l o h].map { |c| "hello".index(c); c }
    %w[e l o h].map(&:index.to("hello")).should == %w[e l o h]
  end
  
  it do
    # %w[e l o h].map { |c| "hello".index(c) }
    %w[e l o h].map(&:index.in("hello")).should == [1, 2, 4, 0]
  end
  
  it do
    # [[1,2], [3,4], []].map { |a| a.pop or 0 }
    [[1,2], [3,4], []].map(&:pop.and_eval("0").if(&:nil?)).should == [2, 4, 0]
  end
  
end


