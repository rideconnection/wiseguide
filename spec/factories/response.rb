FactoryGirl.define do
  factory :response do
    association :answer
    association :question
    association :response_set
  end
end
