Factory.define :answer do |f|
  f.sequence(:text) {|n| "Answer #{n}" }
  f.association :question
end
