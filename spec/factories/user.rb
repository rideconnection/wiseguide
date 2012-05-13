FactoryGirl.define do
  factory :user, :aliases => [:viewer] do
    first_name 'Test'
    last_name 'User'
    email {"user.#{Time.current.to_f}@rideconnection.org"}
    association :organization, :factory => :staff_organization
    level 0
    password "password 1"
    password_confirmation { |u| u.password }

    factory :trainer do
      first_name 'Trainer'
      last_name 'User'
      email {"trainer.#{Time.current.to_f}@rideconnection.org" }
      association :organization, :factory => :staff_organization
      level 50
    end

    factory :admin do
      first_name 'Admin'
      last_name 'User'
      email {"admin.#{Time.current.to_f}@rideconnection.org"}
      association :organization, :factory => :staff_organization
      level 100
    end

    factory :case_manager do
      first_name 'Case'
      last_name 'Manager'
      email {"case.manager.#{Time.current.to_f}@outside.org"}
      association :organization, :factory => :case_mgmt_organization
      level 25
    end
  end
end
