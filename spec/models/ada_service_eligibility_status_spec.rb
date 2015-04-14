require 'spec_helper'

describe AdaServiceEligibilityStatus do
  before do
    @status = FactoryGirl.build(:ada_service_eligibility_status)
  end
  
  it "should create a new instance given valid attributes" do
    @status.valid?.should be_truthy
  end

  it "should require a valid description" do
    @status.name = nil
    @status.valid?.should be_falsey
    @status.name = "A"
    @status.valid?.should be_truthy
  end
end
