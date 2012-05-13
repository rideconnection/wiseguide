require 'spec_helper'

describe TrainingKase do
  before do
    @in_progress = FactoryGirl.create(:disposition, :name => "In Progress")
    
    @valid_attributes = {
      :customer_id       => 1,
      :open_date         => Date.current,
      :referral_source   => "Source",
      :referral_type_id  => 1,
      :disposition       => @in_progress,
      :funding_source_id => 1,
      :county            => Kase::VALID_COUNTIES.values.first
    }

    @valid_kase = TrainingKase.new
    
    # We need to override the mass-assignment filters so we can assign a 
    # valid type attrbiute.
    @valid_kase.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    TrainingKase.new.valid?.should be_false
    @valid_kase.valid?.should be_true
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