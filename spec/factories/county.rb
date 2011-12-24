Factory.define :county do |f|
  f.sequence(:name) {|n| "County #{n}" }
end
