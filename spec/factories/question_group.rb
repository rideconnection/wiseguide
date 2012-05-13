FactoryGirl.define do
  factory :question_group do
    sequence(:text) {|n| "Question Group #{n}" }
  end
end
