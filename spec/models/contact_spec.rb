require 'spec_helper'

describe Contact do
  before do
    @user = Factory(:trainer)
    @kase = Factory(:kase, :assigned_to => @user)
    @contact = Factory.build(:contact, :kase => @kase, :user => @user)
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
    it "should have a customer attribute that returns the associated case's customer" do
      @contact.customer.should eq(@kase.customer)
    end
  end
end