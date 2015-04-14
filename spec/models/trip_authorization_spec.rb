require 'spec_helper'

describe TripAuthorization do
  before do
    @valid_attributes = {
      allowed_trips_per_month: 1,
      start_date:              1.day.from_now,
      end_date:                1.day.from_now,
      disposition_date:        1.day.ago,
      disposition_user_id:     1,
      kase_id:                 1,
    }

    @valid_ta = TripAuthorization.new
    @valid_ta.attributes = @valid_attributes
  end

  it "should create a new instance given valid attributes" do
    TripAuthorization.new.valid?.should be_falsey
    @valid_ta.valid?.should be_truthy
  end

  describe "allowed_trips_per_month" do
    it { should_not accept_values_for(:allowed_trips_per_month, nil, "", -1) }
    it { should accept_values_for(:allowed_trips_per_month, 0, 1, 99) }
  end

  describe "start_date" do
    it { should_not accept_values_for(:start_date, nil, "") }
    it { should accept_values_for(:start_date, Date.current, 1.day.from_now, 1.day.ago) }
  end

  describe "end_date" do
    it { should accept_values_for(:end_date, nil, "", Date.current, 1.day.from_now) }
    it "must be after or equal to the start date" do
      ta = TripAuthorization.new(
        allowed_trips_per_month: 1,
        start_date:              Date.current,
        kase_id:                 1
      )
      ta.should be_valid
      
      ta.end_date = 1.day.ago.to_date
      ta.should_not be_valid
      
      ta.end_date = 1.day.from_now.to_date
      ta.should be_valid
    end
  end

  describe "disposition_date" do
    it { should_not accept_values_for(:disposition_date, 1.day.from_now) }
    it { should accept_values_for(:disposition_date, nil, "", DateTime.current, 1.day.ago) }
  end

  describe "disposition_user_id" do
    it { should accept_values_for(:disposition_user_id, nil, "", 1) }
  end
  
  describe "#complete_disposition" do
    before do
      @u = FactoryGirl.create(:user)
      @ta = TripAuthorization.new(
        allowed_trips_per_month: 1,
        start_date:              Date.current,
        kase_id:                 1
      )
    end
    
    it "has a complete_disposition method" do
      assert_respond_to TripAuthorization.new, :complete_disposition
    end
    
    it "marks the disposition as completed by recording a timestamp and the completing user id" do
      assert_nil @ta.disposition_date
      assert_nil @ta.disposition_user
      
      @ta.complete_disposition(@u)
      
      assert @ta.disposition_date.present?
      assert_equal @ta.disposition_user, @u
    end
  end
end
