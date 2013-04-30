require 'spec_helper'

class TestDevelopmentKase < Kase
 include DevelopmentKaseBehavior
end

describe DevelopmentKaseBehavior do
  before do
    @in_progress = FactoryGirl.create(:disposition, :name => "In Progress")
    
    @valid_attributes = {
      # Required by base Kase class
      :customer_id                         => 1,
      :disposition_id                      => @in_progress.id,
      :open_date                           => Date.current,

      # Required by DevelopmentKaseBehavior module
      :referral_type_id                    => 1,
      
      # Not required by base class or module
      :access_transit_partner_referred_to  => nil,
      :adult_ticket_count                  => nil,
      :assessment_date                     => nil,
      :assessment_language                 => nil,
      :assessment_request_id               => nil,
      :case_manager_id                     => nil,
      :case_manager_notification_date      => nil,
      :close_date                          => nil,
      :county                              => nil,
      :eligible_for_ticket_disbursement    => nil,
      :funding_source_id                   => nil,
      :honored_ticket_count                => nil,
      :household_income                    => nil,
      :household_income_alternate_response => nil,
      :household_size                      => nil,
      :household_size_alternate_response   => nil,
      :medicaid_eligible                   => nil,
      :referral_source                     => nil,
      :scheduling_system_entry_required    => nil,
      :user_id                             => nil,
    }

    @kase = TestDevelopmentKase.new(@valid_attributes)
  end
  
  it "should be valid given valid attributes" do
    @kase.should be_valid
  end
  
  describe "referral_type_id" do
    it { @kase.should accept_values_for(:referral_type_id, 0, 1) }
    it { @kase.should_not accept_values_for(:referral_type_id, nil, "") }
  end

  describe "adult_ticket_count" do
    it { @kase.should accept_values_for(:adult_ticket_count, nil, "", 0, 1, "0", "123") }
    it { @kase.should_not accept_values_for(:adult_ticket_count, "a", 1.1, "1.1", "$1", "123,456", -5) }
  end
  
  describe "honored_ticket_count" do
    it { @kase.should accept_values_for(:honored_ticket_count, nil, "", 0, 1, "0", "123") }
    it { @kase.should_not accept_values_for(:honored_ticket_count, "a", 1.1, "1.1", "$1", "123,456", -5) }
  end
  
  describe "household_income" do
    it { @kase.should accept_values_for(:household_income, nil, "", 0, 1, "0", "123") }
    it { @kase.should_not accept_values_for(:household_income, "a", 1.1, "1.1", "$1", "123,456", -5) }
  end
  
  describe "household_income_alternate_response" do
    it { @kase.should accept_values_for(:household_income_alternate_response, nil, "", "Unknown", "Refused") }
    it { @kase.should_not accept_values_for(:household_income_alternate_response, "Foo") }

    it "should set household_income to nil when valued" do
      @kase.household_income = 1234
      @kase.save!
      @kase.reload
      @kase.household_income.should eq(1234)
      
      @kase.household_income_alternate_response = "Unknown"
      @kase.save!
      @kase.reload
      @kase.household_income.should be_nil
    end
  end
  
  describe "household_size" do
    it { @kase.should accept_values_for(:household_size, nil, "", 0, 1, "0", "123") }
    it { @kase.should_not accept_values_for(:household_size, "a", 1.1, "1.1", "1 person", "123,456", -5) }
  end
  
  describe "household_size_alternate_response" do
    it { @kase.should accept_values_for(:household_size_alternate_response, nil, "", "Unknown", "Refused") }
    it { @kase.should_not accept_values_for(:household_size_alternate_response, "Foo") }

    it "should set household_size to nil when valued" do
      @kase.household_size = 1234
      @kase.save!
      @kase.reload
      @kase.household_size.should eq(1234)
      
      @kase.household_size_alternate_response = "Unknown"
      @kase.save!
      @kase.reload
      @kase.household_size.should be_nil
    end
  end
  
  context "associations" do
    it "should have a referral_type attribute" do
      @kase.should respond_to(:referral_type)
    end
    
    it "should have a funding_source attribute" do
      @kase.should respond_to(:funding_source)
    end
    
    it "should have a assessment_request attribute" do
      @kase.should respond_to(:assessment_request)
    end
    
    it "should have a events attribute" do
      @kase.should respond_to(:events)
    end
    
    it "should have a response_sets attribute" do
      @kase.should respond_to(:response_sets)
    end
    
    it "should have a kase_routes attribute" do
      @kase.should respond_to(:kase_routes)
    end
    
    it "should have a routes attribute" do
      @kase.should respond_to(:routes)
    end
    
    it "should have a outcomes attribute" do
      @kase.should respond_to(:outcomes)
    end
    
    it "should have a referral_documents attribute" do
      @kase.should respond_to(:referral_documents)
    end
    
    it "should have a trip_authorizations attribute" do
      @kase.should respond_to(:trip_authorizations)
    end
  end
  
  context "class scopes" do
    context "for_funding_source_id scope" do
      before do
        @funding_source_1 = FactoryGirl.create(:funding_source)
        @funding_source_2 = FactoryGirl.create(:funding_source)
        
        @funded_kases = []
        @funded_kases << FactoryGirl.create(:development_kase, :funding_source_id => @funding_source_1.id)
        @funded_kases << FactoryGirl.create(:development_kase, :funding_source_id => @funding_source_1.id)
        
        @unfunded_kases = []
        @unfunded_kases << FactoryGirl.create(:development_kase, :funding_source_id => @funding_source_2.id)
        @unfunded_kases << FactoryGirl.create(:development_kase, :funding_source_id => @funding_source_2.id)
        
        # We need to reload these to get the correct sub classes
        @funded_kases   = @funded_kases.map{|k| Kase.find(k.id)}
        @unfunded_kases = @unfunded_kases.map{|k| Kase.find(k.id)}
      end
      
      it "should define a for_funding_source_id scope" do
        # lambda {|funding_source_id| funding_source_id.present? ? where(:funding_source_id => funding_source_id) : where(true) }
        FactoryGirlDevelopmentKase.for_funding_source_id(@funding_source_1.id).should =~ @funded_kases
      end
    end
  end
end
