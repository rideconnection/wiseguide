require 'rails_helper'

RSpec.describe ReferralDocumentResource do
  it "should create a new instance given valid attributes" do
    # We could put this in a before block to take advantage of transactions,
    # but I prefer to explicitly state why we are building a new object, 
    # especially since rebuilding it before each test is overkill, and
    # I can live with knowing I'm breaking convention here by destroying an
    # object from inside a test.
    valid = FactoryGirl.create(:referral_document_resource)
    valid.destroy
  end
  
  context "associations" do    
    it "should required a valid, persisted resource" do
      # With a nil resource
      doc_resource = FactoryGirl.build(:referral_document_resource, :resource => nil)
      doc_resource.valid?.should be_falsey
      doc_resource.errors.keys.should include(:resource)
      doc_resource.errors[:resource].should include("can't be blank")
      
      # With an invalid resource
      resource = FactoryGirl.build(:resource, :name => nil)
      doc_resource.resource = resource
      doc_resource.valid?.should be_falsey
      doc_resource.errors.keys.should include(:resource)
      doc_resource.errors[:resource].should include("is invalid")
      
      # With a valid resource
      doc_resource.resource.name = "Name"
      doc_resource.should be_valid
      doc_resource.save
      doc_resource.resource.should eq(resource)
    end
  end
end
