Factory.define :funding_source do |f|
  f.sequence(:name) {|n| "Funding Source #{n}" }
end