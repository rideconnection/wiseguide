FactoryGirl.define do
  factory :kase, :aliases => [:closed_kase, :training_kase, :closed_training_kase, :case] do
    association :customer
    open_date { Date.yesterday }
    close_date { Date.current }
    referral_source "Source"
    association :referral_type
    association :funding_source
    association :disposition
    association :assigned_to, :factory => :user
    county { Kase::VALID_COUNTIES.values.first }
    type "TrainingKase"

    factory :open_kase, :aliases => [:open_training_kase] do
      close_date ""
      # I hate having to rely on seed data being loaded, but there is special
      # functionality assigned to disposition names.
      disposition { Disposition.find_or_create_by_name_and_type("In Progress", "TrainingKaseDisposition") }
    end

    factory :coaching_kase, :aliases => [:closed_coaching_kase] do
      type "CoachingKase"
      association :disposition, :factory => :coaching_kase_disposition

      factory :open_coaching_kase do
        close_date ""
        disposition { Disposition.find_or_create_by_name_and_type("In Progress", "CoachingKaseDisposition") }
      end
    end
  end
end
