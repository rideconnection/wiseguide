Factory.define :disposition do |f|
  f.sequence(:name) {|n| "Disposition #{n}" }
end