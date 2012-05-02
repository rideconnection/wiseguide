FactoryGirl.define do
  # You can only use FactoryGirl.build on this prototype
  factory :referral_document_prototype, :class => :referral_document do
    association :kase
    last_printed_at nil

    factory :referral_document do
      after_build do |f|
        f.referral_document_resources << FactoryGirl.build(:referral_document_resource, :referral_document => nil)
      end
    end
  end
end
