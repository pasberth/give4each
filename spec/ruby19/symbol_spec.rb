require 'spec_helper'

describe Symbol do
  
  describe "#call" do
    
    it("avaliable when Ruby1.9", :ruby => 1.9) do
      :new.call(2).to_proc.call(Array).should == [nil, nil]

      # for ruby1.8 reasons, I test this code by the eval
      eval(":new.(2)").to_proc.call(Array).should == [nil, nil]
    end

    it("not avaliable when Ruby1.8", :ruby => 1.8) do
      expect { :new.call(2).to_proc.call(Array) }.should raise_error NoMethodError
    end
  end
end