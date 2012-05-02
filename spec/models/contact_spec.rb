require 'spec_helper'

describe Contact do
  before do
    @customer = FactoryGirl.create(:customer)
    @customer_kase = FactoryGirl.create(:kase, :customer => @customer)
    @contact = FactoryGirl.build(:contact, :customer => @customer)
  end
  
  it "should create a new instance given valid attributes" do
    @contact.valid?.should be_true
  end

  it "should require a valid description" do
    @contact.description = nil
    @contact.valid?.should be_false
    @contact.description = "A"
    @contact.valid?.should be_true
  end
  
  it "should require a valid date_time before or equal to the current time" do
    @contact.date_time = nil
    @contact.valid?.should be_false

    @contact.date_time = Time.current + 1.minute
    @contact.valid?.should be_false

    @contact.date_time = Time.current
    @contact.valid?.should be_true
  end
  
  context "associations" do
    it "should have a required customer attribute" do
      @contact.customer = nil
      @contact.valid?.should be_false
    end
    
    it "should have a kase attribute" do
      @contact.kase = @customer_kase
      @contact.kase.should eq(@customer_kase)
    end
  end
  
  context "without a case association" do
    before do
      @kase = FactoryGirl.create(:kase)
    end
    
    it "should should allow a nil kase association" do
      @contact.kase = nil
      @contact.valid?.should be_true
    end
    
    it "should limit the kase association to kases belonging to the associated customer" do
      @contact.kase = @kase
      @contact.valid?.should be_false
      @contact.kase = @customer_kase
      @contact.valid?.should be_true
    end
  end
end