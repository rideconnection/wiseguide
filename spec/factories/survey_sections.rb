FactoryGirl.define do
  factory :survey_section do
    sequence(:title) {|n| "Survey Section #{n}" }
    survey
    display_order 0
  end
end
