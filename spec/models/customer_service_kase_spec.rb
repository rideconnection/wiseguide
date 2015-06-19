require 'rails_helper'

RSpec.describe CustomerServiceKase do
  before do    
    @valid_attributes = {
      access_transit_partner_referred_to: nil,
      adult_ticket_count: nil,
      agency_id: 1,
      assessment_date: nil,
      assessment_language: nil,
      assessment_request_id: nil,
      case_manager_id: nil,
      case_manager_notification_date: nil,
      category: CustomerServiceKase::COMPLAINT_CATEGORIES.first,
      close_date: Date.current,
      county: nil,
      customer_id: 1,
      disposition_id: FactoryGirl.create(:disposition, name: CustomerServiceKase::COMPLAINT_ONLY_DISPOSITIONS.first).id,
      eligible_for_ticket_disbursement: nil,
      funding_source_id: nil,
      honored_ticket_count: nil,
      household_income: nil,
      household_income_alternate_response: nil,
      household_size: nil,
      household_size_alternate_response: nil,
      medicaid_eligible: nil,
      open_date: Date.current,
      referral_source: nil,
      referral_type_id: nil,
      scheduling_system_entry_required: nil,
    }

    @valid_kase = CustomerServiceKase.new
    
    @valid_kase.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    CustomerServiceKase.new.valid?.should be_falsey
    @valid_kase.valid?.should be_truthy
  end

  describe "agency_id" do
    it { should accept_values_for(:agency_id, 1) }
    it { should_not accept_values_for(:agency_id, nil, "") }
  end

  describe "category" do
    it { should accept_values_for(:category, *CustomerServiceKase::CATEGORY) }
    it { should_not accept_values_for(:category, nil, "", "foo") }
  end

  describe "disposition validation" do
    before do
      # CustomerServiceKase::CATEGORY = [
      #   "commendations", 
      #   "comments",
      #   "incidents", 
      #   "policy complaints", 
      #   "service complaints", 
      # ]
      # CustomerServiceKase::COMPLAINT_CATEGORIES = ["policy complaints", "service complaints"]
      # CustomerServiceKase::COMPLAINT_ONLY_DISPOSITIONS = ["Substantiated", "Unsubstantiated", "Indeterminable"]
      # CustomerServiceKase::NON_COMPLAINT_DISPOSITIONS  = ["Completed"]
      
      @complaint_cservice_kase = FactoryGirl.build(:customer_service_kase, category: CustomerServiceKase::COMPLAINT_CATEGORIES.first)
      @non_complaint_cservice_kase = FactoryGirl.build(:customer_service_kase, :category => (CustomerServiceKase::CATEGORY - CustomerServiceKase::COMPLAINT_CATEGORIES).first)
      
      @in_progress     = Disposition.find_by_name("In Progress") || FactoryGirl.create(:disposition, name: "In Progress")
      @substantiated   = Disposition.find_by_name("Substantiated") || FactoryGirl.create(:disposition, name: "Substantiated")
      @unsubstantiated = Disposition.find_by_name("Unsubstantiated") || FactoryGirl.create(:disposition, name: "Unsubstantiated")
      @indeterminable  = Disposition.find_by_name("Indeterminable") || FactoryGirl.create(:disposition, name: "Indeterminable")
      @completed       = Disposition.find_by_name("Completed") || FactoryGirl.create(:disposition, name: "Completed")

      @complaint_only_dispositions = [@substantiated.id, @unsubstantiated.id, @indeterminable.id]
      @non_complaint_dispositions  = [@completed.id]
    end
    
    it { @complaint_cservice_kase.should accept_values_for(:disposition_id, *@complaint_only_dispositions) }
    it { @complaint_cservice_kase.should_not accept_values_for(:disposition_id, nil, "", *@non_complaint_dispositions) }

    it { @non_complaint_cservice_kase.should accept_values_for(:disposition_id, *@non_complaint_dispositions) }
    it { @non_complaint_cservice_kase.should_not accept_values_for(:disposition_id, nil, "", *@complaint_only_dispositions) }
  end
end
