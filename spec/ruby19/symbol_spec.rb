require 'spec_helper'

describe Symbol do
  
  describe "#call" do
    
    it("avaliable when Ruby1.9", :ruby => 1.9) do
      :new.call(2).to_proc.call(Array).should == [nil, nil]

      # for ruby1.8 reasons, I test this code by the eval
      eval(":new.(2)").to_proc.call(Array).should == [nil, nil]
    end

    it("not avaliable when Ruby1.8", :ruby => 1.8) do
      expect { :new.call(2) }.should raise_error NoMethodError
    end
  end

  describe "#[]" do

    context "MUST not destroy origial behavior of the core Symbol#[]", :ruby => 1.9 do
      it { :new[1].should == 'e' }
      it { :new[3].should equal nil }
      it { :new[0, 2].should == 'ne' }
      it { :new[/./].should == 'n' }
    end
    
    context "avaliable when Ruby1.8", :ruby => 1.8 do
      it { :new[2].to_proc.call(Array).should == [nil, nil] }
    end
  end
end