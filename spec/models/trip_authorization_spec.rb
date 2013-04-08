require 'spec_helper'

describe TripAuthorization do
  before do
    @valid_attributes = {
      allowed_trip_per_month: 1,
      end_date:               "2013-04-08",
      user_id:                1,
      disposition_date:       "2013-04-08 14:52:24",
      disposition_user_id:    1,
    }

    @valid_ta = TripAuthorization.new
    @valid_ta.attributes = @valid_attributes
  end

  it "should create a new instance given valid attributes" do
    TripAuthorization.new.valid?.should be_false
    @valid_ta.valid?.should be_true
  end

  describe "allowed_trip_per_month" do
    it { should_not accept_values_for(:allowed_trip_per_month, nil, "", 0, -1) }
    it { should accept_values_for(:allowed_trip_per_month, 1, 99) }
  end

  describe "end_date" do
    it { should accept_values_for(:end_date, nil, "", "2013-04-08") }
  end

  describe "user_id" do
    it { should_not accept_values_for(:user_id, nil, "") }
    it { should accept_values_for(:user_id, 1) }
  end

  describe "disposition_date" do
    it { should_not accept_values_for(:disposition_date, nil, "") }
    it { should accept_values_for(:disposition_date, "2013-04-08 15:07:00") }
  end

  describe "disposition_user_id" do
    it { should_not accept_values_for(:disposition_user_id, nil, "") }
    it { should accept_values_for(:disposition_user_id, 1) }
  end
end
