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
  
  describe "#of_loose" do
    let(:receiver) { Object.new }
    let(:result) { :inspect.of_loose(:to_str).to_proc.call(receiver) }
    let(:expected_result) { (receiver.to_str rescue nil).inspect }
    subject { result }
    it { should == expected_result }
  end
  
  describe "#and_loose" do
    let(:receiver) { Object.new }
    let(:result) { :to_enum.and_loose(:map, &:to_s).to_proc.call(receiver) }
    let(:expected_result) do
      begin
        receiver.to_enum.map { |item| item.to_s }
      rescue NoMethodError
        nil
      end
    end
    subject { result }
    it { should == expected_result }
  end

  describe "#of_loose_*" do
    let(:receiver) { Object.new }
    let(:result) { :inspect.of_loose_to_str.to_proc.call(receiver) }
    let(:expected_result) { (receiver.to_str rescue nil).inspect }
    subject { result }
    it { should == expected_result }
  end

  
  describe "#and_loose_*" do
    let(:receiver) { Object.new }
    let(:result) { :to_enum.and_loose_map(&:to_s).to_proc.call(receiver) }
    let(:expected_result) do
      begin
        receiver.to_enum.map { |item| item.to_s }
      rescue NoMethodError
        nil
      end
    end
    subject { result }
    it { should == expected_result }
  end
  
end