FactoryGirl.define do
  factory :response_set do
    association :survey
    association :user, :factory => :trainer
    association :kase
  end
end
