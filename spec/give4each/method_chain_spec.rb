require 'spec_helper'

describe Give4Each::MethodChain do

  let(:to_s_method) { Give4Each::MethodChain.new :to_s }
  subject { to_s_method }
  
  Proc.instance_methods.each do |proc_method|
    it { should respond_to proc_method }
  end
  
  describe "#to_proc" do
    let(:receiver) { "hello world" }
    let(:result) { to_s_method.to_proc.call receiver }
    subject { result }
    it { should == "hello world" }
  end

end