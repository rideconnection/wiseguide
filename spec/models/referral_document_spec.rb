require 'spec_helper'

describe ReferralDocument do
  it "should create a new instance given valid attributes" do
    # We could put this in a before block to take advantage of transactions,
    # but I prefer to explicitly state why we are building a new object, 
    # especially since rebuilding it before each test is overkill, and
    # I can live with knowing I'm breaking convention here by destroying an
    # object from inside a test.
    valid = Factory(:referral_document)
    valid.destroy
  end
  
  context "associations" do
    before do
      @refdoc = Factory(:referral_document)
    end
    
    it "should be able add referral document resources" do
      resource = @refdoc.resources.create(:resource => Factory(:resource))
      @refdoc.resources.count.should eq(1)
      @refdoc.resources.first.should eq(resource)
    end
    
    it "should only be printable when one or more referral document resources are associated" do
      @refdoc.printable?.should be_false
      @refdoc.resources.create(:resource => Factory(:resource))
      @refdoc.printable?.should be_true
    end
  end
end
