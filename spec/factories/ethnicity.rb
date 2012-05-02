FactoryGirl.define do
  factory :ethnicity do
    sequence(:name) {|n| "Ethnicity #{n}" }
  end
end
