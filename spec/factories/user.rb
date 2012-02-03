Factory.define :user do |f|
  f.first_name 'Test'
  f.sequence(:last_name) {|n| "User ##{n}"}
  f.sequence(:email) {|n| "user.#{n}@rideconnection.org" }
  f.association :organization, :factory => :parent_organization
  f.level 0
  f.password "password"
  f.password_confirmation { |u| u.password }
end

Factory.define :trainer, :parent => :user do |f|
  f.first_name 'Trainer'
  f.last_name 'User'
  f.sequence(:email) {|n| "trainer.#{n}@rideconnection.org" }
  f.association :organization, :factory => :parent_organization
  f.level 50
end

Factory.define :admin, :parent => :user do |f|
  f.first_name 'Admin'
  f.last_name 'User'
  f.sequence(:email) {|n| "admin.#{n}@rideconnection.org" }
  f.association :organization, :factory => :parent_organization
  f.level 100
end

Factory.define :case_manager, :parent => :user do |f|
  f.first_name 'Case'
  f.last_name 'Manager'
  f.sequence(:email) {|n| "case.manager.#{n}@outside.org" }
  f.association :organization, :factory => :case_mgmt_organization
  f.level 25
end
