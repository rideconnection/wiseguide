require "#{Rails.root}/db/seeds.rb"

# Create users that will be used in the scenarios
Factory.create(:user,
               :email => 'admin@rideconnection.org',
               :level => 100)
Factory.create(:user,
               :email => 'trainer@rideconnection.org',
               :level => 50)
