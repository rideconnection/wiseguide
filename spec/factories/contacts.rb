FactoryGirl.define do
  factory :contact do
    association :user, :factory => :trainer
    association :customer
    date_time Time.current
    description "My Contact"
  end
  
  factory :contact_with_open_training_kase, :parent => :contact do
    after_build {|c| c.kase = Factory(:open_training_kase, :customer => c.customer)}
  end
end
