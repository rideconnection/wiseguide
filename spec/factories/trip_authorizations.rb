# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip_authorization do
    allowed_trips_per_month 1
    start_date {Date.current}
    association :kase
  end
end
