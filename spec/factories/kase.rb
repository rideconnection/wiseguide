Factory.define :kase do |f|
  f.association :customer
  f.open_date { Date.yesterday }
  f.close_date { Date.today }
  f.referral_source "Source"
  f.association :referral_type
  f.association :funding_source
  f.association :disposition
  f.county { Kase::VALID_COUNTIES.values.first }
end

Factory.define :open_kase, :parent => :kase do |f|
  f.close_date ""
  f.association :disposition, :name => "In Progress"
end
