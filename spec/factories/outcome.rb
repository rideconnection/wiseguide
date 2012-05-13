FactoryGirl.define do
  factory :outcome do
    association :kase
    association :trip_reason
    exit_trip_count 1
    exit_vehicle_miles_reduced 1
  end
end
