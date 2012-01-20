Factory.define :kase do |f|
  f.association :customer
  f.open_date { Date.yesterday }
  f.close_date { Date.current }
  f.referral_source "Source"
  f.association :referral_type
  f.association :funding_source
  f.association :disposition, :name => "Successful"
  f.association :assigned_to, :factory => :user
  f.county { Kase::VALID_COUNTIES.values.first }
end

# Just an alias
Factory.define :closed_kase, :parent => :kase do |f|; end

Factory.define :open_kase, :parent => :kase do |f|
  f.close_date ""
  f.association :disposition, :name => "In Progress"
end
