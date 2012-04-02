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
  
  describe "case_manager association" do
    it "should require a valid, persisted case manager" do
      kase = CoachingKase.new
      kase.case_manager = nil
      kase.valid?
      kase.errors.keys.should include(:case_manager)
      kase.errors[:case_manager].should include("can't be blank")
      
      kase.case_manager = @case_manager
      kase.valid?
      kase.errors.keys.should_not include(:case_manager)
    end
  end
end