# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  # You can only use Factory.build on this prototype
  factory :referral_document_prototype, :class => :referral_document do
    association :kase
    last_printed_at nil
  end

  factory :referral_document, :parent => :referral_document_prototype do
    after_build do |f|
      f.referral_document_resources << Factory.build(:referral_document_resource, :referral_document => nil)
    end
  end
end
