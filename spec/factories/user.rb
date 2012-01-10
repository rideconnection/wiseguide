Factory.define :user do |f|
  f.sequence(:email) {|n| "user.#{n}@rideconnection.org" }
  f.level 0
  f.password "password"
  f.password_confirmation { |u| u.password }
end

Factory.define :trainer, :parent => :user do |f|
  f.sequence(:email) {|n| "trainer.#{n}@rideconnection.org" }
  f.level 50
end

Factory.define :admin, :parent => :user do |f|
  f.sequence(:email) {|n| "admin.#{n}@rideconnection.org" }
  f.level 100
end
