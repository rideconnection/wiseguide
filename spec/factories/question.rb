FactoryGirl.define do
  factory :question do
    sequence(:text) {|n| "Question #{n}" }
    association :survey_section

    factory :question_in_group do
      association :question_group
    end
  end
end

