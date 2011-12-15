Factory.define :user do |f|
  f.email                 "user@rideconnection.org"
  f.level                 0
  f.password              "password"
  f.password_confirmation { |u| u.password }
end
