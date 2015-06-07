FactoryGirl.define do
  factory :contact, aliases: [:contact_event, :customer_contact, :customer_contact_event] do
    association :user, factory: :trainer
    date_time Time.current
    description "My Contact"    
    association :contactable, factory: :customer
    
    factory :kase_contact, aliases: [:kase_contact_event] do
      association :contactable, factory: :training_kase
    end
    
    factory :assessment_request_contact, aliases: [:assessment_request_contact_event] do
      association :contactable, factory: :assessment_request
    end
  end
end
