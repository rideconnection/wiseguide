Factory.define :disposition do |f|
  f.name {"TrainingKaseDisposition #{Time.current.to_f}" }
  f.type "TrainingKaseDisposition"
end

# aliases
Factory.define :training_kase_disposition, :parent => :disposition do |f|; end

Factory.define :coaching_kase_disposition, :parent => :disposition do |f|
  f.name {"CoachingKaseDisposition #{Time.current.to_f}" }
  f.type "CoachingKaseDisposition"
end
