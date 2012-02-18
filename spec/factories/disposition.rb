Factory.define :disposition do |f|
  f.sequence(:name) {|n| "Disposition #{n}" }
  f.type "TrainingKaseDisposition"
end

# aliases
Factory.define :training_kase_disposition, :parent => :disposition do |f|; end

Factory.define :coaching_kase_disposition, :parent => :disposition do |f|; 
  f.type "CoachingKaseDisposition"
end
