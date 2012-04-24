FactoryGirl.define do
  factory :question do |f|
    f.sequence(:text) {|n| "Question #{n}" }
    f.association :survey_section
  end

  factory :question_in_group, :parent => :question do |f|
    f.association :question_group
  end
end
