Factory.define :question do |f|
  f.sequence(:text) {|n| "Question #{n}" }
  f.association :survey_section
end

Factory.define :question_in_group, :parent => :question do |f|
  f.association :question_group
end
