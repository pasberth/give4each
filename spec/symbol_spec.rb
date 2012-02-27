require 'spec_helper'

describe Symbol do

  describe "#to_proc" do
    let(:receiver) { Array }
    let(:args) { [2] }
    let(:result) { :new.to_proc.call(receiver, *args) }
    subject { result }

    it { should == [nil, nil] }
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
  
end