# This gives us a valid subclass name so we can create a valid kase model
class FactoryGirlKase < Kase; end

# A subclass with only the develoment kase behavior module mixed in
class FactoryGirlDevelopmentKase < Kase
  include DevelopmentKaseBehavior
end

FactoryGirl.define do
  trait :base_kase do
    customer
    open_date { Date.yesterday }
    close_date { Date.current }
    disposition
  end
  
  trait :development_kase do
    referral_type
    household_income 1
    household_size 1
  end
  
  trait :open_kase do
    close_date ""
    disposition { Disposition.find_by_name("In Progress") || FactoryGirl.create(:disposition, :name => "In Progress") }
  end
  
  factory :kase, :class => FactoryGirlKase, :aliases => [:closed_kase], :traits => [:base_kase] do
    factory :open_kase, traits: [:open_kase]
  end
  
  factory :development_kase, :class => FactoryGirlDevelopmentKase, :traits => [:base_kase, :development_kase] do
    factory :open_development_kase, traits: [:open_kase]
  end
  
  factory :training_kase, :aliases => [:closed_training_kase], :traits => [:base_kase, :development_kase] do
    county { Kase::VALID_COUNTIES.values.first }
    funding_source
    referral_source "Source"
    
    factory :open_training_kase, traits: [:open_kase]
  end

  factory :coaching_kase, :aliases => [:closed_coaching_kase], :traits => [:base_kase, :development_kase] do
    case_manager
    
    factory :open_coaching_kase, traits: [:open_kase]
  end

  factory :customer_service_kase, :aliases => [:closed_customer_service_kase], :traits => [:base_kase] do
    agency
    category CustomerServiceKase::COMPLAINT_CATEGORIES.first
    disposition { Disposition.find_by_name(CustomerServiceKase::COMPLAINT_ONLY_DISPOSITIONS.first) || FactoryGirl.create(:disposition, :name => CustomerServiceKase::COMPLAINT_ONLY_DISPOSITIONS.first) }
    
    factory :open_customer_service_kase, traits: [:open_kase]
  end
end
