FactoryGirl.define do
  factory :contact do
    association :kase
    association :user, :factory => :trainer
    date_time Time.current
    description "My Contact"
  end
end
