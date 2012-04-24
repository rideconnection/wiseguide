FactoryGirl.define do
  factory :response do |f|
    f.association :answer
    f.association :question
    f.association :response_set
  end
end
