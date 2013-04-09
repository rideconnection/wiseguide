require 'spec_helper'

describe TripAuthorization do
  before do
    @valid_attributes = {
      allowed_trips_per_month: 1,
      end_date:                1.day.from_now,
      disposition_date:        1.day.ago,
      disposition_user_id:     1,
      coaching_kase_id:        1,
    }

    @valid_ta = TripAuthorization.new
    @valid_ta.attributes = @valid_attributes
  end

  it "should create a new instance given valid attributes" do
    TripAuthorization.new.valid?.should be_false
    @valid_ta.valid?.should be_true
  end

  describe "allowed_trips_per_month" do
    it { should_not accept_values_for(:allowed_trips_per_month, nil, "", 0, -1) }
    it { should accept_values_for(:allowed_trips_per_month, 1, 99) }
  end

  describe "end_date" do
    it { should_not accept_values_for(:end_date, 1.days.ago) }
    it { should accept_values_for(:end_date, nil, "", Date.current, 1.day.from_now) }
  end

  describe "disposition_date" do
    it { should_not accept_values_for(:disposition_date, nil, "", 1.day.from_now) }
    it { should accept_values_for(:disposition_date, DateTime.current, 1.day.ago) }
  end

  describe "disposition_user_id" do
    it { should_not accept_values_for(:disposition_user_id, nil, "") }
    it { should accept_values_for(:disposition_user_id, 1) }
  end
end
