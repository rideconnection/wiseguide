# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip_authorization do
    allowed_trips_per_month 1
    end_date {Date.current}
    disposition_date {DateTime.current}
    association :disposition_user, :factory => :user
    association :kase
  end
end
