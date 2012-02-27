require File.dirname(__FILE__) + '/spec_helper'

describe "when using for Enumerable" do
  
  let(:langs) { %w[c++ lisp] }
  let(:suffix) { "er" }
  
  context "langs.map &:upcase.of(:+, suffix)" do
    let(:result) { langs.map &:upcase.of(:+, suffix) }
    let(:expected_result) { langs.map { |lang| (lang + suffix).upcase } }
    subject { result }
    it { should == expected_result }
  end
  
  context "langs.map &:upcase.and(:+, suffix)" do
    let(:result) { langs.map &:upcase.and(:+, suffix) }
    let(:expected_result) { langs.map { |lang| lang.upcase + suffix } }
    subject { result }
    it { should == expected_result }
  end
  
  context "langs.map &:push.to(*receivers)" do
    let(:receivers) { Array.new(3) { [] } }
    let(:destructed_receivers) { Array.new(3) { langs } }
    let(:result) { langs.map &:push.to(*receivers) }
    let(:expected_result) { langs }
    before { result }

    describe "receivers" do
      subject { receivers }
      it { should == destructed_receivers }
    end
    
    describe "result" do
      subject { result }
      it { should == expected_result }
    end
  end

  context "llangs.map &:capitalize.and_push.to(*receivers)" do
    let(:receivers) { Array.new(3) { [] } }
    let(:destructed_receivers) { Array.new(3) { langs.map { |lang| lang.capitalize } } }
    let(:result) { langs.map &:capitalize.and_push.to(*receivers) }
    let(:expected_result) { langs.map &:capitalize }
    before { result }
    
    describe "receivers" do
      subject { receivers }
      it { should == destructed_receivers }
    end
    
    describe "result" do
      subject { result }
      it { should == expected_result }
    end
  end

  context "langs.map &:capitalize.of_push.to(*receivers)" do
    let(:receivers) { Array.new(3) { [] } }
    let(:destructed_receivers) { Array.new(3) { langs } }
    let(:result) { langs.map &:capitalize.of_push.to(*receivers) }
    let(:expected_result) { langs.map &:capitalize }
    before { result }
    
    describe "receivers" do
      subject { receivers }
      it { should == destructed_receivers }
    end
    
    describe "result" do
      subject { result }
      it { should == expected_result }
    end
  end
  
  
  context "langs.map &:+.in(receiver)" do
    let(:receiver) { "The " }
    let(:result) { langs.map &:+.in(receiver) }
    let(:expected_result) { langs.map { |lang| receiver + lang } }
    subject { result }
    it { should == expected_result }
  end
  
  context "(1..5).map &:at.in(langs).or(default_value)" do
    let(:default_value) { "none" }
    let(:result) { (1..5).map &:at.in(langs).or(default_value) }
    let(:expected_result) { (1..5).map { |i| langs.at(i) or default_value } }
    subject { result }
    it { should == expected_result }
  end

end