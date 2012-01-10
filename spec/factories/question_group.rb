Factory.define :question_group do |f|
  f.sequence(:text) {|n| "Question Group #{n}" }
end