require 'spec_helper'

describe Symbol do

  describe "#to_proc" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.to_proc.call(receiver, *args) }
    subject { result }

    it { should == [nil, nil] }
  end

  describe "#as_method" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.as_method.to_proc.call(receiver, *args) }
    subject { result }

    it { should == [nil, nil] }
  end

  describe "#as_setter" do
    let(:receiver) { Class.new { attr_accessor :example }.new }
    subject { receiver }

    its(:example) { should be_nil }
    it do
      :example.as_setter.to_proc.call(receiver, "example");
      subject.example.should == "example"
    end
  end
  
  describe "#of" do
    let(:receiver) { "ruby" }
    let(:args) { ["ist"] }
    let(:result) { :upcase.of(:+, *args).to_proc.call(receiver) }
    subject { result }
    it { should == "RUBYIST" }
  end
  
  describe "#and" do
    let(:receiver) { "ruby" }
    let(:args) { ["ist"] }
    let(:result) { :upcase.and(:+, *args).to_proc.call(receiver) }
    subject { result }
    it { should == "RUBYist" }
  end
  
  describe "#of_*" do
    let(:receiver) { "ruby" }
    let(:args) { ["ist"] }
    let(:result) { :upcase.of_concat(*args).to_proc.call(receiver) }
    subject { result }
    it { should == "RUBYIST" }
  end
  
  describe "#and_*" do
    let(:receiver) { "ruby" }
    let(:args) { ["ist"] }
    let(:result) { :upcase.and_concat(*args).to_proc.call(receiver) }
    subject { result }
    it { should == "RUBYist" }
  end
  
  describe "#with" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.with(*args).to_proc.call(receiver) }
    subject { result }
    it { should == [nil, nil] }
  end

  describe "#with args given" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.with.to_proc.call(receiver, *args) }
    subject { result }
    it { should == [nil, nil] }
  end
  
  describe "#to" do
    let(:receiver) { ["hello"] }
    let(:args) { [["world"]] }
    let(:result) { :concat.to(receiver).to_proc.call(*args) }
    before { result }
    
    describe "receiver" do
      subject { receiver }
      it { should == ["hello", "world"] }
    end
    
    describe "result" do
      subject { result }
      it { should == ["world"] }
    end
  end

  describe "#in" do
    let(:receiver) { ["hello"] }
    let(:args) { [["world"]] }
    let(:result) { :concat.in(receiver).to_proc.call(*args) }
    before { result }
    
    describe "receiver" do
      subject { receiver }
      it { should == ["hello", "world"] }
    end
    
    describe "result" do
      subject { result }
      it { should == ["hello", "world"] }
    end
  end
  
  describe "#rescue" do
    let(:array) { ["can_convert_into_symbol", ["Can't convert into Symbol"]] }

    context "default" do
      let(:result) { array.map &:to_sym.rescue }
      subject { result }
      it { should == [:can_convert_into_symbol, nil] }
    end

    context "speciafy return value." do
      let(:result) { array.map &:to_sym.rescue(:None) }
      subject { result }
      it { should == [:can_convert_into_symbol, :None] }
    end
    
    it "can not rescue the to_sym" do
      expect { array.map &:to_sym.and_to_s.rescue }.should raise_error NoMethodError
    end

    it "can rescue the to_sym" do
      array.map(&:to_sym.and_to_s.all.rescue).should == ["can_convert_into_symbol", nil]
    end
  end
  
  describe "all" do
    let(:receiver) { ["hello"] }
    let(:arg1) { ["world"] }
    let(:arg2) { ["last"] }

    example do
      :+.and(:+, arg2).all.in(receiver).to_proc.call(arg1).should == ["hello", "world", "last"]
    end
  end
end