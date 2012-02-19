Factory.define :kase do |f|
  f.association :customer
  f.open_date { Date.yesterday }
  f.close_date { Date.current }
  f.referral_source "Source"
  f.association :referral_type
  f.association :funding_source
  f.association :disposition
  f.association :assigned_to, :factory => :user
  f.county { Kase::VALID_COUNTIES.values.first }
  f.type "TrainingKase"
end

# aliases
Factory.define :open_kase, :parent => :kase do |f|
  f.close_date ""
  # I hate having to rely on seed data being loaded, but there is special
  # functionality assigned to disposition names.
  f.disposition { Disposition.find_by_name_and_type("In Progress", "TrainingKaseDisposition") }
end

Factory.define :coaching_kase, :parent => :kase do |f|
  f.type "CoachingKase"
  f.association :disposition, :factory => :coaching_kase_disposition
end

Factory.define :open_coaching_kase, :parent => :coaching_kase do |f|
  f.close_date ""
  f.disposition { Disposition.find_by_name_and_type("In Progress", "CoachingKaseDisposition") }
end

# aliases
Factory.define :closed_kase,          :parent => :kase do |f|; end
Factory.define :training_kase,        :parent => :kase do |f|; end
Factory.define :closed_training_kase, :parent => :closed_kase do |f|; end
Factory.define :open_training_kase,   :parent => :open_kase do |f|; end
Factory.define :closed_coaching_kase, :parent => :coaching_kase do |f|; end
