Factory.define :outcome do |f|
  f.association :kase
  f.association :trip_reason
  f.exit_trip_count 1
  f.exit_vehicle_miles_reduced 1
end

