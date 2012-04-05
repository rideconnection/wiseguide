require 'spec_helper'

describe Kase do
  before do
    @in_progress = Factory(:disposition, :name => "In Progress")
  end
  
  describe "customer_id" do
    it { should accept_values_for(:customer_id, 0, 1) }
    it { should_not accept_values_for(:customer_id, nil, "") }
  end

  describe "open_date" do
    it { should accept_values_for(:open_date, Date.current, Date.yesterday) }
    it { should_not accept_values_for(:open_date, nil, "", Date.current + 1.minute, Date.tomorrow) }
  end

  describe "close_date" do
    before do
      @not_in_progress = Factory(:disposition, :name => "Not In Progress")
    end
    
    it "should not be required if the disposition is 'In Progress'" do
      kase = Kase.new
      kase.disposition = @in_progress
      kase.valid?
      kase.errors.keys.should_not include(:close_date)
    end
    
    it "should be required if the disposition is not 'In Progress'" do
      kase = Kase.new
      kase.disposition = @not_in_progress
      kase.valid?
      kase.errors.keys.should include(:close_date)
      kase.errors[:close_date].should include("can't be blank")
      
      kase.close_date = Date.current
      kase.valid?
      kase.errors.keys.should_not include(:close_date)
    end
    
    it { should accept_values_for(:close_date, nil, "", Date.current, Date.tomorrow, Date.yesterday) }
  end

  describe "referral_source" do
    it { should accept_values_for(:referral_source, "a") }
    it { should_not accept_values_for(:referral_source, nil, "") }
  end

  describe "referral_type_id" do
    it { should accept_values_for(:referral_type_id, 0, 1) }
    it { should_not accept_values_for(:referral_type_id, nil, "") }
  end

  describe "user_id" do
    it { should accept_values_for(:user_id, nil, "", 0, 1) }
  end

  describe "funding_source_id" do
    it { should accept_values_for(:funding_source_id, nil, "", 0, 1) }
  end

  describe "disposition_id" do
    before do
      @not_in_progress = Factory(:disposition, :name => "Not In Progress")
    end
    
    it "cannot be 'In Progress' if case is closed" do
      kase = Kase.new
      kase.disposition = @in_progress
      kase.close_date = nil
      kase.valid?
      kase.errors.keys.should_not include(:disposition_id)
      
      kase.close_date = Date.current
      kase.valid?
      kase.errors.keys.should include(:disposition_id)
      kase.errors[:disposition_id].should include("cannot be 'In Progress' if case is closed")
      
      kase.disposition = @not_in_progress
      kase.valid?
      kase.errors.keys.should_not include(:disposition_id)
    end
    
    it { should accept_values_for(:disposition_id, nil, "", 0, 1) }
  end

  describe "county" do
    it { should accept_values_for(:county, nil, "", "a") }
  end

  describe "type" do
    it { should accept_values_for(:type, "CoachingKase", "TrainingKase") }
    it { should_not accept_values_for(:type, nil, "", "FooKase") }
  end

  describe "assessment_date" do
    it { should accept_values_for(:assessment_date, nil, "", Date.current, Date.tomorrow, Date.yesterday) }
  end

  describe "assessment_language" do
    it { should accept_values_for(:assessment_language, nil, "", "a") }
  end

  describe "case_manager_notification_date" do
    it { should accept_values_for(:case_manager_notification_date, nil, "", Date.current, Date.tomorrow, Date.yesterday) }
  end

  describe "case_manager_id" do
    it { should accept_values_for(:case_manager_id, nil, "", 0, 1) }
  end

  describe "assessment_request_id" do
    it { should accept_values_for(:assessment_request_id, nil, "", 0, 1) }
  end
  
  describe "household_size" do
    it { should accept_values_for(:household_size, nil, "", 0, 1, "0", "123") }
    it { should_not accept_values_for(:household_size, "a", 1.1, "1.1", "1 person", "123,456") }
  end
  
  describe "household_size_alternate_response" do
    it { should accept_values_for(:household_size_alternate_response, nil, "", "Unknown", "Refused") }
    it { should_not accept_values_for(:household_size_alternate_response, "Foo") }

    before do
      @kase = Factory(:kase)
    end
    
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
  
  describe "household_income" do
    it { should accept_values_for(:household_income, nil, "", 0, 1, "0", "123") }
    it { should_not accept_values_for(:household_income, "a", 1.1, "1.1", "$1", "123,456") }
  end
  
  describe "household_income_alternate_response" do
    it { should accept_values_for(:household_income_alternate_response, nil, "", "Unknown", "Refused") }
    it { should_not accept_values_for(:household_income_alternate_response, "Foo") }
    
    before do
      @kase = Factory(:kase)
    end
    
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
  
  context "associations" do
    before do
      @kase = Kase.new
    end
    
    it "should have a customer attribute" do
      @kase.should respond_to(:customer)
    end
    
    it "should have a referral_type attribute" do
      @kase.should respond_to(:referral_type)
    end
    
    it "should have a funding_source attribute" do
      @kase.should respond_to(:funding_source)
    end
    
    it "should have a disposition attribute" do
      @kase.should respond_to(:disposition)
    end
    
    it "should have a assigned_to attribute which references a user" do
      @kase.should respond_to(:assigned_to)
      @kase.build_assigned_to().class.name.should eq("User")
    end
    
    it "should have a assessment_request attribute" do
      @kase.should respond_to(:assessment_request)
    end
    
    it "should have a contacts attribute" do
      @kase.should respond_to(:contacts)
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
  end
  
  context "class scopes" do
    context "assignment scopes" do
      before do
        @user_1 = Factory(:user)
        @user_2 = Factory(:user)

        @assigned_kases = []
        @assigned_kases << Factory(:kase, :assigned_to => @user_1)
        @assigned_kases << Factory(:kase, :assigned_to => @user_1)
        @assigned_kases << Factory(:kase, :assigned_to => @user_1)

        @not_assigned_kases = []
        @not_assigned_kases << Factory(:kase, :assigned_to => @user_2)
        @not_assigned_kases << Factory(:kase, :assigned_to => @user_2)
        @not_assigned_kases << Factory(:kase, :assigned_to => @user_2)

        @unassigned_kases = []
        @unassigned_kases << Factory(:kase, :assigned_to => nil)
        @unassigned_kases << Factory(:kase, :assigned_to => nil)
        @unassigned_kases << Factory(:kase, :assigned_to => nil)
        
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
        @open_kase_today        = Factory(:open_kase, :open_date => Date.current)
        @open_kase_yesterday    = Factory(:open_kase, :open_date => Date.yesterday)
        @open_kase_2_months_ago = Factory(:open_kase, :open_date => 2.months.ago)
        @open_kase_3_months_ago = Factory(:open_kase, :open_date => 3.months.ago)
                
        @closed_kase_today        = Factory(:closed_kase, :open_date => Date.current, :close_date => Date.current)
        @closed_kase_yesterday    = Factory(:closed_kase, :open_date => Date.yesterday, :close_date => Date.yesterday)
        @closed_kase_2_months_ago = Factory(:closed_kase, :open_date => 2.months.ago, :close_date => 2.months.ago)
        @closed_kase_3_months_ago = Factory(:closed_kase, :open_date => 3.months.ago, :close_date => 3.months.ago)

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
        Kase.opened_in_range(2.months.ago..Date.yesterday).should =~ [@open_kase_yesterday, @closed_kase_yesterday, @open_kase_2_months_ago, @closed_kase_2_months_ago]
      end

      it "should define a open_in_range scope" do
        # lambda{|date_range| where("NOT (COALESCE(kases.close_date,?) < ? OR kases.open_date > ?)", date_range.begin, date_range.begin, date_range.end)}
        Kase.open_in_range(2.months.ago..Date.yesterday).should =~ [@open_kase_yesterday, @closed_kase_yesterday, @open_kase_2_months_ago, @closed_kase_2_months_ago, @open_kase_3_months_ago]
      end

      it "should define a closed scope" do
        # where('close_date IS NOT NULL')
        Kase.closed.should =~ [@closed_kase_today, @closed_kase_yesterday, @closed_kase_2_months_ago, @closed_kase_3_months_ago]
      end

      it "should define a closed_in_range scope" do
        # lambda{|date_range| where(:close_date => date_range)}
        Kase.closed_in_range(2.months.ago..Date.yesterday).should =~ [@closed_kase_yesterday, @closed_kase_2_months_ago]
      end
    end

    context "successful scope" do
      before do
        @successful = Factory(:disposition, :name => "Successful")
        @not_successful = Factory(:disposition, :name => "Not Successful")
        
        @succesful_kase = Factory(:closed_kase, :disposition => @successful)
        @unsuccesful_kase = Factory(:closed_kase, :disposition => @not_successful)

        # We need to reload these to get the correct sub classes
        @succesful_kase = Kase.find(@succesful_kase.id)
        @unsuccesful_kase = Kase.find(@unsuccesful_kase.id)
      end
      
      it "should define a successful scope" do
        # lambda{where("disposition_id IN (?)", Disposition.successful.collect(&:id))}
        Kase.successful.should =~ [@succesful_kase]
      end
    end
    
    pending "resolution scopes" do
      # TODO - make these pass
      # I don't have enough information about what these are supposed to do to
      # setup the test properly.
      
      before do
        @successful = Factory(:disposition, :name => "Successful")
        @not_successful = Factory(:disposition, :name => "Not Successful")
        
        debugger
        
        @three_month_follow_ups = []
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 3.months.ago)
        @three_month_follow_ups << kase
        
        kase = Factory(:closed_kase, :disposition => @not_successful, :close_date => 3.months.ago)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 4.months.ago)
        kase.outcomes << Factory(:outcome, :three_month_unreachable => true, :three_month_trip_count => nil)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 1.month.ago)
        kase.outcomes << Factory(:outcome, :three_month_unreachable => true, :three_month_trip_count => 3)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 3.months.ago)
        kase.outcomes << Factory(:outcome, :three_month_unreachable => false, :three_month_trip_count => nil)
        @three_month_follow_ups << kase
        
        @six_month_follow_ups = []
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 6.months.ago)
        @six_month_follow_ups << kase

        kase = Factory(:closed_kase, :disposition => @not_successful, :close_date => 6.months.ago)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 7.months.ago)
        kase.outcomes << Factory(:outcome, :six_month_unreachable => true, :six_month_trip_count => nil)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 5.month.ago)
        kase.outcomes << Factory(:outcome, :six_month_unreachable => true, :six_month_trip_count => 3)
        
        kase = Factory(:closed_kase, :disposition => @successful, :close_date => 6.months.ago)
        kase.outcomes << Factory(:outcome, :six_month_unreachable => false, :six_month_trip_count => nil)
        @six_month_follow_ups << kase
        
        # We need to reload these to get the correct sub classes
        @three_month_follow_ups = @three_month_follow_ups.map{|k| Kase.find(k.id)}
        @six_month_follow_ups   = @six_month_follow_ups.map{|k| Kase.find(k.id)}
      end
      
      it "should define a has_three_month_follow_ups_due scope" do
        # lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id=kases.id AND (three_month_unreachable = ? OR three_month_trip_count IS NOT NULL))', 3.months.ago + 1.week, true)}
        Kase.has_three_month_follow_ups_due.should =~ @three_month_follow_ups
      end

      it "should define a has_six_month_follow_ups_due scope" do
        # lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id = kases.id AND (six_month_unreachable = ? OR six_month_trip_count IS NOT NULL))', 6.months.ago + 1.week, true)}
        Kase.has_six_month_follow_ups_due.should =~ @six_month_follow_ups
      end
    end
    
    context "for_funding_source_id scope" do
      before do
        @funding_source_1 = Factory(:funding_source)
        @funding_source_2 = Factory(:funding_source)
        
        @funded_kases = []
        @funded_kases << Factory(:kase, :funding_source => @funding_source_1)
        @funded_kases << Factory(:kase, :funding_source => @funding_source_1)

        @unfunded_kases = []
        @unfunded_kases << Factory(:kase, :funding_source => @funding_source_2)
        @unfunded_kases << Factory(:kase, :funding_source => @funding_source_2)

        # We need to reload these to get the correct sub classes
        @funded_kases   = @funded_kases.map{|k| Kase.find(k.id)}
        @unfunded_kases = @unfunded_kases.map{|k| Kase.find(k.id)}

      end
      
      it "should define a for_funding_source_id scope" do
        # lambda {|funding_source_id| funding_source_id.present? ? where(:funding_source_id => funding_source_id) : where(true) }
        Kase.for_funding_source_id(@funding_source_1.id).should =~ @funded_kases
      end
    end
  end
end