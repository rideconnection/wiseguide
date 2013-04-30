FactoryGirl.define do
  factory :answer do
    sequence(:text) {|n| "Answer #{n}" }
    response_class "text"
    question
    display_order 0
  end
end
