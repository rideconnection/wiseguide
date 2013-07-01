FactoryGirl.define do
  factory :disposition, :aliases => [:training_kase_disposition] do
    name {"TrainingKaseDisposition #{Time.current.to_f}" }
    type "TrainingKaseDisposition"

    factory :coaching_kase_disposition do
      name {"CoachingKaseDisposition #{Time.current.to_f}" }
      type "CoachingKaseDisposition"
    end

    factory :customer_service_kase_disposition do
      name {"CustomerServiceKaseDisposition #{Time.current.to_f}" }
      type "CustomerServiceKaseDisposition"
    end
  end
end
