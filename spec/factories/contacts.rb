FactoryGirl.define do
  factory :contact, :aliases => [:contact_event] do
    association :user, :factory => :trainer
    association :customer
    date_time Time.current
    description "My Contact"
    factory :contact_with_open_training_kase, :aliases => [:contact_event_with_open_training_kase] do
      after_build {|c| c.kase = FactoryGirl.create(:open_training_kase, :customer => c.customer)}
    end
  end
end
