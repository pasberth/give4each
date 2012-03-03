require 'spec_helper'

describe Symbol do

  describe "#to_proc" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.to_proc.call(receiver, *args) }
    subject { result }

    it { should == [nil, nil] }
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

  describe "#as_key" do
    example do
      receiver = { :key => "value" }
      result = :key.as_key.to_proc.call(receiver)
      result.should == "value" 
    end
    
    it "search as the key is a String if :key as Symbol is not found." do
      receiver = { "key" => "value" }
      result = :key.as_key.to_proc.call(receiver)
      result.should == "value" 
    end
  end
end