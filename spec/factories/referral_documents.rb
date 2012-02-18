# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :referral_document do
    association :kase
    last_printed_at nil
  end
end
