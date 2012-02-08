Factory.define :answer do |f|
  f.sequence(:text) {|n| "Answer #{n}" }
  f.response_class "text"
  f.association :question
end
