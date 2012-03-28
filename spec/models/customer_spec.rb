require 'spec_helper'

describe Customer do
  before do
    @customer = Factory.build(:customer)
  end
  
  it "should create a new instance given valid attributes" do
    @customer.valid?.should be_true
  end
  
  describe "veteran_status" do
    it "should allow true" do
      @customer.veteran_status = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.veteran_status = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.veteran_status = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "spouse_of_veteran_status" do
    it "should allow true" do
      @customer.spouse_of_veteran_status = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.spouse_of_veteran_status = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.spouse_of_veteran_status = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "honored_citizen_cardholder" do
    it "should allow true" do
      @customer.honored_citizen_cardholder = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.honored_citizen_cardholder = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.honored_citizen_cardholder = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "primary_language" do
    it "should allow a text value" do
      @customer.primary_language = "A"
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.primary_language = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "ada_service_eligibility_status_id" do
    before do
      @ada_service_eligibility_status = Factory(:ada_service_eligibility_status)
    end
    
    it "should allow an integer value" do
      @customer.ada_service_eligibility_status_id = @ada_service_eligibility_status.id
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.ada_service_eligibility_status_id = nil
      @customer.valid?.should be_true
    end    
  end
  
  describe "associations" do
    it "should have a ada_service_eligibility_status attribute" do
      @customer.should respond_to(:ada_service_eligibility_status)
    end
  end
end
