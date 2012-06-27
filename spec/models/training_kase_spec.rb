require 'spec_helper'

describe TrainingKase do
  before do    
    @valid_attributes = {
      :customer_id                         => 1,
      :open_date                           => Date.current,
      :close_date                          => Date.current,
      :referral_source                     => "Source",
      :referral_type_id                    => 1,
      :funding_source_id                   => 1,
      :disposition_id                      => FactoryGirl.create(:disposition).id,
      :county                              => Kase::VALID_COUNTIES.values.first,
      :type                                => "TrainingKase",
      :assessment_date                     => nil,
      :assessment_language                 => nil,
      :case_manager_notification_date      => nil,
      :case_manager_id                     => nil,
      :assessment_request_id               => nil,
      :household_size                      => nil,
      :household_income                    => nil,
      :household_size_alternate_response   => nil,
      :household_income_alternate_response => nil,
      :medicaid_eligible                   => nil,
      :scheduling_system_entry_required    => nil
    }

    @valid_kase = TrainingKase.new
    
    @valid_kase.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    TrainingKase.new.valid?.should be_false
    @valid_kase.valid?.should be_true
  end

  describe "referral_source" do
    it { should accept_values_for(:referral_source, "a") }
    it { should_not accept_values_for(:referral_source, nil, "") }
  end

  describe "funding_source_id" do
    it { should accept_values_for(:funding_source_id, 0, 1) }
    it { should_not accept_values_for(:funding_source_id, nil, "") }
  end

  describe "county" do
    it { should accept_values_for(:county, Kase::VALID_COUNTIES.values.first, Kase::VALID_COUNTIES.values.last) }
    it { should_not accept_values_for(:county, nil, "", "a") }
  end
end