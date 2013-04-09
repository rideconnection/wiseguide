# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip_authorization do
    allowed_trips_per_month 1
    end_date "2013-04-08"
    disposition_date "2013-04-08 14:52:24"
    association :disposition_user, :factory => :user
  end
end
