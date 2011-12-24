Factory.define :ethnicity do |f|
  f.sequence(:name) {|n| "Ethnicity #{n}" }
end
