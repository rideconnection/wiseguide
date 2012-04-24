FactoryGirl.define do
  factory :disposition do |f|
    f.name {"TrainingKaseDisposition #{Time.current.to_f}" }
    f.type "TrainingKaseDisposition"
  end

  # aliases
  factory :training_kase_disposition, :parent => :disposition do |f|
  end

  factory :coaching_kase_disposition, :parent => :disposition do |f|
    f.name {"CoachingKaseDisposition #{Time.current.to_f}" }
    f.type "CoachingKaseDisposition"
  end
end
