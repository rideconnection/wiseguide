FactoryGirl.define do
  factory :answer do
    sequence(:text) {|n| "Answer #{n}" }
    response_class "text"
    association :question
  end
end
