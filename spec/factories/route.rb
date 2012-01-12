Factory.define :route do |f|
  f.sequence(:name) {|n| "Route #{n}" }
end
