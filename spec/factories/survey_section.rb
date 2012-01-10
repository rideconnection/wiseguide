Factory.define :survey_section do |f|
  f.sequence(:title) {|n| "Survey Section #{n}" }
  f.association :survey
end