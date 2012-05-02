FactoryGirl.define do
  factory :referral_type do
    sequence(:name) {|n| "Referral Type #{n}" }
  end
end
