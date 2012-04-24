require 'spec_helper'

describe CoachingKase do
  before do
    @in_progress = Factory(:disposition, :name => "In Progress")
    
    @case_manager = Factory(:case_manager)
    
    @valid_attributes = {
      :customer_id      => 1,
      :open_date        => Date.current,
      :referral_source  => "Source",
      :referral_type_id => 1,
      :disposition      => @in_progress,
      :case_manager     => @case_manager
    }

    @valid_kase = CoachingKase.new
    
    # We need to override the mass-assignment filters so we can assign a 
    # valid type attrbiute.
    @valid_kase.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    CoachingKase.new.valid?.should be_false
    @valid_kase.valid?.should be_true
  end

  describe "assessment_date" do
    it { should accept_values_for(:assessment_date, nil, "", Date.current, Date.yesterday) }
    it { should_not accept_values_for(:assessment_date, Date.tomorrow) }
  end

  describe "case_manager_notification_date" do
    it { should accept_values_for(:case_manager_notification_date, nil, "", Date.current, Date.yesterday) }
    it { should_not accept_values_for(:case_manager_notification_date, Date.tomorrow) }
  end

  describe "case_manager_id" do
    it { should accept_values_for(:case_manager_id, nil, "", 0, 1) }
  end
  
  describe "medicaid_eligible" do
    it "should allow true" do
      @valid_kase.medicaid_eligible = true
      @valid_kase.valid?.should be_true
    end

    it "should allow false" do
      @valid_kase.medicaid_eligible = false
      @valid_kase.valid?.should be_true
    end

    it "should allow nil" do
      @valid_kase.medicaid_eligible = nil
      @valid_kase.valid?.should be_true
    end
  end
  
  describe "case_manager association" do
    before do
      @invalid_unpersisted_case_manager = Factory.build(:case_manager, :email => nil)
      
      # We can't use Factory.build here because the returned object will be an
      # instance of Kase, not CoachingKase, and thus the case_manager 
      # association wouldn't be available yet.
      @new_kase = CoachingKase.new
    end
    
    it "should require the case manager to be a valid object, when specified" do
      @new_kase.case_manager = nil
      # Don't bother testing if the object is valid or not because the other
      # validations won't be met yet, just trigger the validations and make 
      # sure the error collection doesn't contain a :case_manager key
      @new_kase.valid?
      @new_kase.errors.keys.should_not include(:case_manager)

      @new_kase.case_manager = @invalid_unpersisted_case_manager
      @new_kase.valid?
      @new_kase.errors.keys.should include(:case_manager)
      @new_kase.errors[:case_manager].should include("is invalid")
      
      @new_kase.case_manager = @case_manager
      @new_kase.valid?
      @new_kase.errors.keys.should_not include(:case_manager)
    end
  end
end