Factory.define :survey do |f|
  f.sequence(:title) {|n| "Survey #{n}" }
end