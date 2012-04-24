FactoryGirl.define do
  factory :ethnicity do |f|
    f.sequence(:name) {|n| "Ethnicity #{n}" }
  end
end
