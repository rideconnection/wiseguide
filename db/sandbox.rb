require 'factory_girl'
require "#{Rails.root}/config/environment.rb"

def load_sandbox_data
  raise 'Sandboxing not permitted in production.' if Rails.env == 'production' 
  create_users
  create_customers
  create_simple_survey
  create_sample_date
end

def create_sample_date
  [
    :assessment_request,
    :assessment_request_contact,
    :coaching_kase,
    :contact,
    :disposition,
    :kase_contact,
    :open_coaching_kase,
    :open_kase,
    :outcome,
    :referral_document,
    :trip_authorization,
  ].each do |f|
    FactoryGirl.create(f)
  end
end

def create_users
  puts "Creating test users"
  puts "-- ALL TEST USERS HAVE PASSWORD \"password 1\""
  FactoryGirl.create(:admin,        :password => "password 1", :email => 'admin@rideconnection.org')
  puts "-- Created test user admin@rideconnection.org"
  FactoryGirl.create(:trainer,      :password => "password 1", :email => 'trainer@rideconnection.org')
  puts "-- Created test user trainer@rideconnection.org"
  FactoryGirl.create(:user,         :password => "password 1", :email => 'viewer@rideconnection.org')
  puts "-- Created test user viewer@rideconnection.org"
  FactoryGirl.create(:case_manager, :password => "password 1", :email => 'case_manager@rideconnection.org')
  puts "-- Created test user case_manager@rideconnection.org"
  puts "Finished creating test users"
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
    FactoryGirl.create(:customer,
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

def create_simple_survey
  # This will create all of the appropriate associations too
  FactoryGirl.create(:answer)
end
