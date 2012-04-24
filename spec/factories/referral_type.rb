FactoryGirl.define do
  factory :referral_type do |f|
    f.sequence(:name) {|n| "Referral Type #{n}" }
  end
end
