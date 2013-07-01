require 'spec_helper'

class TestKase < Kase; end

describe Kase do
  before do
    @in_progress = FactoryGirl.create(:disposition, :name => "In Progress")
    
    @valid_attributes = {
      # Required by base Kase class
      :customer_id                         => 1,
      :disposition_id                      => @in_progress.id,
      :open_date                           => Date.current,
      
      # Not required by base class
      :access_transit_partner_referred_to  => nil,
      :adult_ticket_count                  => nil,
      :agency_id                           => nil,
      :assessment_date                     => nil,
      :assessment_language                 => nil,
      :assessment_request_id               => nil,
      :case_manager_id                     => nil,
      :case_manager_notification_date      => nil,
      :category                            => nil,
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
      :referral_type_id                    => nil,
      :scheduling_system_entry_required    => nil,
      :user_id                             => nil,
    }
    
    @kase = TestKase.new(@valid_attributes)
  end
  
  it "should be valid given valid attributes" do
    @kase.should be_valid
  end

  describe "customer_id" do
    it { @kase.should accept_values_for(:customer_id, 0, 1) }
    it { @kase.should_not accept_values_for(:customer_id, nil, "") }
  end

  describe "disposition_id" do
    it { @kase.should accept_values_for(:disposition_id, 0, 1) }
    it { @kase.should_not accept_values_for(:disposition_id, nil, "") }

    it "cannot be 'In Progress' if case is closed" do
      not_in_progress = FactoryGirl.create(:disposition, :name => "Not In Progress")

      @kase.disposition = @in_progress
      @kase.close_date = nil
      @kase.should be_valid
      
      @kase.close_date = Date.current
      @kase.should_not be_valid
      @kase.errors.keys.should include(:disposition_id)
      @kase.errors[:disposition_id].should include("cannot be 'In Progress' if case is closed")
      
      @kase.disposition = not_in_progress
      @kase.should be_valid
    end
  end

  describe "open_date" do
    it { @kase.should accept_values_for(:open_date, Date.current, Date.yesterday) }
    it { @kase.should_not accept_values_for(:open_date, nil, "", Date.current + 1.minute, Date.tomorrow) }
  end

  describe "type" do
    it { @kase.should accept_values_for(:type, "CoachingKase", "TrainingKase", "TestKase") }
    it { @kase.should_not accept_values_for(:type, nil, "", "FooKase") }
  end
  
  describe "close_date" do
    it { @kase.should accept_values_for(:close_date, nil, "", Date.current, Date.tomorrow, Date.yesterday) }

    it "should not be required if the disposition is 'In Progress'" do
      @kase.disposition = @in_progress
      @kase.should be_valid
    end
    
    it "should be required if the disposition is not 'In Progress'" do
      not_in_progress = FactoryGirl.create(:disposition, :name => "Not In Progress")
      
      @kase.disposition = not_in_progress
      @kase.should_not be_valid
      @kase.errors.keys.should include(:close_date)
      @kase.errors[:close_date].should include("can't be blank")
      
      @kase.close_date = Date.current
      @kase.should be_valid
    end
  end
  
  context "associations" do
    it "should have a customer attribute" do
      @kase.should respond_to(:customer)
    end
    
    it "should have a disposition attribute" do
      @kase.should respond_to(:disposition)
    end
    
    it "should have a assigned_to attribute which references a user" do
      @kase.should respond_to(:assigned_to)
      @kase.build_assigned_to().class.name.should eq("User")
    end
    
    it "should know what referral types are available to each kase" do
      coaching_type = ReferralType.find_or_create_by_name("CC - Test")
      training_type = ReferralType.find_or_create_by_name("TC - Test")

      coaching_kase = FactoryGirl.create(:coaching_kase)
      training_kase = FactoryGirl.create(:training_kase)

      ReferralType.for_kase(coaching_kase).should include(coaching_type)
      ReferralType.for_kase(coaching_kase).should_not include(training_type)

      ReferralType.for_kase(training_kase).should include(training_type)
      ReferralType.for_kase(training_kase).should_not include(coaching_type)
    end

    describe "contacts association" do
      before do
        # We need a valid subclass here to get around a validation on the
        # contact model
        @kase = FactoryGirl.create(:training_kase)
        
        @contacts = [
          FactoryGirl.create(:contact, :contactable => @kase),
          FactoryGirl.create(:contact, :contactable => @kase)
        ]
      end
      
      it "should have a contacts attribute" do
        @kase.should respond_to(:contacts)
      end

      it "should return an empty array if no contacts have been associated" do
        @contacts.map(&:destroy)
        @kase.contacts(true)
        @kase.contacts.should == []
      end

      it "should return the proper contacts" do
        @kase.contacts.should =~ @contacts
      end
    end
  end
  
  context "class scopes" do
    context "assignment scopes" do
      before do
        @user_1 = FactoryGirl.create(:user)
        @user_2 = FactoryGirl.create(:user)

        @assigned_kases = []
        @assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_1)
        @assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_1)
        @assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_1)

        @not_assigned_kases = []
        @not_assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_2)
        @not_assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_2)
        @not_assigned_kases << FactoryGirl.create(:kase, :assigned_to => @user_2)

        @unassigned_kases = []
        @unassigned_kases << FactoryGirl.create(:kase, :assigned_to => nil)
        @unassigned_kases << FactoryGirl.create(:kase, :assigned_to => nil)
        @unassigned_kases << FactoryGirl.create(:kase, :assigned_to => nil)
        
        # We need to reload these to get the correct sub classes
        @assigned_kases     = @assigned_kases.map{|k| Kase.find(k.id)}
        @not_assigned_kases = @not_assigned_kases.map{|k| Kase.find(k.id)}
        @unassigned_kases   = @unassigned_kases.map{|k| Kase.find(k.id)}
      end
    
      it "should define a assigned_to scope" do
        # lambda {|user| where(:user_id => user.id) }
        Kase.assigned_to(@user_1).should =~ @assigned_kases
      end

      it "should define a not_assigned_to scope" do
        # lambda {|user| where('user_id <> ?',user.id)}
        Kase.not_assigned_to(@user_1).should =~ @not_assigned_kases
      end

      it "should define a unassigned scope" do
        # where(:user_id => nil)
        Kase.unassigned.should =~ @unassigned_kases
      end
    end
    
    context "date range scopes" do
      before do
        @open_kase_today        = FactoryGirl.create(:open_kase, :open_date => Date.current)
        @open_kase_yesterday    = FactoryGirl.create(:open_kase, :open_date => Date.yesterday)
        @open_kase_2_months_ago = FactoryGirl.create(:open_kase, :open_date => 2.months.ago)
        @open_kase_3_months_ago = FactoryGirl.create(:open_kase, :open_date => 3.months.ago)
                
        @closed_kase_today        = FactoryGirl.create(:closed_kase, :open_date => Date.current, :close_date => Date.current)
        @closed_kase_yesterday    = FactoryGirl.create(:closed_kase, :open_date => Date.yesterday, :close_date => Date.yesterday)
        @closed_kase_2_months_ago = FactoryGirl.create(:closed_kase, :open_date => 2.months.ago, :close_date => 2.months.ago)
        @closed_kase_3_months_ago = FactoryGirl.create(:closed_kase, :open_date => 3.months.ago, :close_date => 3.months.ago)

        # We need to reload these to get the correct sub classes
        @open_kase_today          = Kase.find(@open_kase_today.id)
        @open_kase_yesterday      = Kase.find(@open_kase_yesterday.id)
        @open_kase_2_months_ago   = Kase.find(@open_kase_2_months_ago.id)
        @open_kase_3_months_ago   = Kase.find(@open_kase_3_months_ago.id)
        @closed_kase_today        = Kase.find(@closed_kase_today.id)
        @closed_kase_yesterday    = Kase.find(@closed_kase_yesterday.id)
        @closed_kase_2_months_ago = Kase.find(@closed_kase_2_months_ago.id)
        @closed_kase_3_months_ago = Kase.find(@closed_kase_3_months_ago.id)
      end
      
      it "should define a open scope" do
        # where(:close_date => nil)
        Kase.open.should =~ [@open_kase_today, @open_kase_yesterday, @open_kase_2_months_ago, @open_kase_3_months_ago]
      end

      it "should define a opened_in_range scope" do
        # lambda{|date_range| where(:open_date => date_range)}
        Kase.opened_in_range(2.months.ago.to_date..Date.yesterday).should =~ [@open_kase_yesterday, @closed_kase_yesterday, @open_kase_2_months_ago, @closed_kase_2_months_ago]
      end

      it "should define a open_in_range scope" do
        # lambda{|date_range| where("NOT (COALESCE(kases.close_date,?) < ? OR kases.open_date > ?)", date_range.begin, date_range.begin, date_range.end)}
        Kase.open_in_range(2.months.ago.to_date..Date.yesterday).should =~ [@open_kase_yesterday, @closed_kase_yesterday, @open_kase_2_months_ago, @closed_kase_2_months_ago, @open_kase_3_months_ago]
      end

      it "should define a closed scope" do
        # where('close_date IS NOT NULL')
        Kase.closed.should =~ [@closed_kase_today, @closed_kase_yesterday, @closed_kase_2_months_ago, @closed_kase_3_months_ago]
      end

      it "should define a closed_in_range scope" do
        # lambda{|date_range| where(:close_date => date_range)}
        Kase.closed_in_range(2.months.ago.to_date..Date.yesterday).should =~ [@closed_kase_yesterday, @closed_kase_2_months_ago]
      end
    end

    context "successful scope" do
      before do
        @successful = FactoryGirl.create(:disposition, :name => "Successful")
        @not_successful = FactoryGirl.create(:disposition, :name => "Not Successful")
        
        @succesful_kase = FactoryGirl.create(:closed_kase, :disposition => @successful)
        @unsuccesful_kase = FactoryGirl.create(:closed_kase, :disposition => @not_successful)

        # We need to reload these to get the correct sub classes
        @succesful_kase = Kase.find(@succesful_kase.id)
        @unsuccesful_kase = Kase.find(@unsuccesful_kase.id)
      end
      
      it "should define a successful scope" do
        # lambda{where("disposition_id IN (?)", Disposition.successful.collect(&:id))}
        Kase.successful.should =~ [@succesful_kase]
      end
    end
    
    context "resolution scopes" do
      # TODO
      pending "I don't have enough information about what these are supposed to do to setup the test properly."
      
      # before do
      #   @successful = FactoryGirl.create(:disposition, :name => "Successful")
      #   @not_successful = FactoryGirl.create(:disposition, :name => "Not Successful")
      #   
      #   debugger
      #   
      #   @three_month_follow_ups = []
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 3.months.ago)
      #   @three_month_follow_ups << kase
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @not_successful, :close_date => 3.months.ago)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 4.months.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :three_month_unreachable => true, :three_month_trip_count => nil)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 1.month.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :three_month_unreachable => true, :three_month_trip_count => 3)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 3.months.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :three_month_unreachable => false, :three_month_trip_count => nil)
      #   @three_month_follow_ups << kase
      #   
      #   @six_month_follow_ups = []
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 6.months.ago)
      #   @six_month_follow_ups << kase
      # 
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @not_successful, :close_date => 6.months.ago)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 7.months.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :six_month_unreachable => true, :six_month_trip_count => nil)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 5.month.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :six_month_unreachable => true, :six_month_trip_count => 3)
      #   
      #   kase = FactoryGirl.create(:closed_kase, :disposition => @successful, :close_date => 6.months.ago)
      #   kase.outcomes << FactoryGirl.create(:outcome, :six_month_unreachable => false, :six_month_trip_count => nil)
      #   @six_month_follow_ups << kase
      #   
      #   # We need to reload these to get the correct sub classes
      #   @three_month_follow_ups = @three_month_follow_ups.map{|k| Kase.find(k.id)}
      #   @six_month_follow_ups   = @six_month_follow_ups.map{|k| Kase.find(k.id)}
      # end
      # 
      # it "should define a has_three_month_follow_ups_due scope" do
      #   # lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id=kases.id AND (three_month_unreachable = ? OR three_month_trip_count IS NOT NULL))', 3.months.ago + 1.week, true)}
      #   Kase.has_three_month_follow_ups_due.should =~ @three_month_follow_ups
      # end
      # 
      # it "should define a has_six_month_follow_ups_due scope" do
      #   # lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id = kases.id AND (six_month_unreachable = ? OR six_month_trip_count IS NOT NULL))', 6.months.ago + 1.week, true)}
      #   Kase.has_six_month_follow_ups_due.should =~ @six_month_follow_ups
      # end
    end
  end
end
