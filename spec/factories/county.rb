FactoryGirl.define do
  factory :county do |f|
    f.sequence(:name) {|n| "County #{n}" }
  end
end
