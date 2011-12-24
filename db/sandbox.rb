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
  street_names = [
    'NW Davis St',
    'NW Everett St',
    'NW Flanders St',
    'SW 1st Ave',
    'SW 2nd Ave',
    'SW 3rd Ave',
    'SW 4th Ave',
    'SW 5th Ave',
    'SW 6th Ave',
    'SW 7th Ave',
    'SW Alder St',
    'SW Broadway St',
    'SW Columbia St',
    'SW Jefferson St',
    'SW Main St',
    'SW Morrison St',
    'SW Washington St',
    'W Burnside St',
  ]
  
  20.times do
    Factory.create(:customer,
      :first_name     => Faker::Name.first_name,
      :last_name      => Faker::Name.last_name,
      :email          => Faker::Internet.email,
      :ethnicity_id   => Ethnicity.all.sample.id,
      :birth_date     => "#{1930+rand(50)}-#{1+rand(12)}-#{1+rand(28)}",
      :gender         => ::ALL_GENDERS.sample[1],
      :phone_number_1 => "503-555-#{1000+rand(9000)}",
      :address        => "#{1+rand(500)} #{street_names.sample}",
      :city           => 'Portland',
      :state          => 'OR',
      :zip            => "9720#{1+rand(9)}",
      :county         => County.all.sample.name
    )
  end
end
