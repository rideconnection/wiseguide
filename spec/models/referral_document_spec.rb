require 'spec_helper'

describe ReferralDocument do
  before do
    @resource = Factory.build(:referral_document_resource, :referral_document => nil)
  end

  it "should create a new instance given valid attributes" do
    valid = Factory.build(:referral_document_prototype)
    valid.resources << @resource
    valid.valid?.should be_true
  end
  
  context "associations" do
    before do
      @refdoc = Factory(:referral_document)
    end
    
    it "should be able add referral document resources" do
      expect{@refdoc.resources << @resource}.to change{@refdoc.resources.count}.by(1)
      @refdoc.resources.last.should eq(@resource)
    end
    
    it "should require at least one referral document resources are associated" do
      refdoc = Factory.build(:referral_document_prototype)
      refdoc.valid?.should be_false
      refdoc.resources << @resource
      refdoc.valid?.should be_true
    end
  end
end
