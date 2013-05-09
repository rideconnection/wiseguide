require 'spec_helper'

describe CoachingKase do
  before do    
    @case_manager = FactoryGirl.create(:case_manager)

    @valid_attributes = {
      :access_transit_partner_referred_to  => nil,
      :adult_ticket_count                  => nil,
      :agency_id                           => nil,
      :assessment_date                     => nil,
      :assessment_language                 => nil,
      :assessment_request_id               => nil,
      :case_manager_id                     => nil,
      :case_manager_notification_date      => nil,
      :category                            => nil,
      :close_date                          => Date.current,
      :county                              => nil,
      :customer_id                         => 1,
      :disposition_id                      => FactoryGirl.create(:disposition).id,
      :eligible_for_ticket_disbursement    => nil,
      :funding_source_id                   => nil,
      :honored_ticket_count                => nil,
      :household_income                    => 1,
      :household_income_alternate_response => nil,
      :household_size                      => 1,
      :household_size_alternate_response   => nil,
      :medicaid_eligible                   => nil,
      :open_date                           => Date.current,
      :referral_source                     => nil,
      :referral_type_id                    => 1,
      :scheduling_system_entry_required    => nil,
      :type                                => "CoachingKase",
      :user_id                             => nil,
    }

    @valid_kase = CoachingKase.new

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
    before do
      @invalid_unpersisted_case_manager = FactoryGirl.build(:case_manager, :email => nil)
      
      # We can't use FactoryGirl.build here because the returned object will be an
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
