FactoryGirl.define do
  factory :route do |f|
    f.sequence(:name) {|n| "Route #{n}" }
  end
end
