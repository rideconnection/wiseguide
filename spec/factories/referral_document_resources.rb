FactoryGirl.define do
  factory :referral_document_resource do
    association :referral_document
    association :resource
  end
end
