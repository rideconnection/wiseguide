require 'factory_girl'
require "#{Rails.root}/config/environment.rb"

def load_sandbox_data
  raise 'Sandboxing not permitted in production.' if Rails.env == 'production' 
  create_users
  create_customers
end

def create_users
  Factory.create(:user,
                 :email => 'admin@rideconnection.org',
                 :level => 100)
  Factory.create(:user,
                 :email => 'trainer@rideconnection.org',
                 :level => 50)
  Factory.create(:user,
                 :email => 'viewer@rideconnection.org',
                 :level => 0)
end

def create_customers
  20.times do
    Factory.create(:customer)
  end
end
