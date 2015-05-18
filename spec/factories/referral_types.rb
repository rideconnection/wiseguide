FactoryGirl.define do
  factory :referral_type do
    sequence(:name) {|n| "CC Referral Type #{n}"}
  end
end
