require 'ffaker'
require 'factory_girl'
require "#{Rails.root}/config/environment.rb"

def load_sandbox_data
  raise 'Sandboxing not permitted in production.' if Rails.env == 'production'
  ActiveRecord::Base.transaction do
    puts "Starting to load sandbox data"
    puts "Creating test users"
    create_users
    puts "Creating sample customers"
    create_customers
    puts "Creating sample surveys"
    create_simple_survey
    puts "Creating sample data"
    create_sample_date
    puts "Finished loading sandbox data"
  end
end

def create_sample_date
  FactoryGirl.create :assessment_request
  FactoryGirl.create :assessment_request_contact
  FactoryGirl.create :coaching_kase
  FactoryGirl.create :contact
  FactoryGirl.create :disposition
  FactoryGirl.create :kase_contact
  FactoryGirl.create :open_coaching_kase
  FactoryGirl.create :open_kase
  FactoryGirl.create :outcome
  FactoryGirl.create :referral_document
  FactoryGirl.create :trip_authorization
end

def create_users
  password = 'password 1'
  puts "-- ALL TEST USERS HAVE PASSWORD \"#{password}\""
  {
    admin:        'admin@rideconnection.org',
    trainer:      'trainer@rideconnection.org',
    user:         'viewer@rideconnection.org',
    case_manager: 'case_manager@rideconnection.org',
  }.each do |role, email|
    FactoryGirl.create(role, password: password, email: email)
    puts "-- Created test user #{email}"
  end
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
      first_name: FFaker::Name.first_name,
      last_name: FFaker::Name.last_name,
      email: FFaker::Internet.email,
      ethnicity_id: Ethnicity.all.sample.id,
      birth_date: "#{1930+rand(50)}-#{1+rand(12)}-#{1+rand(28)}",
      gender: ::ALL_GENDERS.sample[1],
      phone_number_1: "503-555-#{1000+rand(9000)}",
      address: "#{1+rand(500)} #{street_names.sample}",
      city: 'Portland',
      state: 'OR',
      zip: "9720#{1+rand(9)}",
      county: County.all.sample.name
    )
  end
end

def create_simple_survey
  # This will create all of the appropriate associations too
  FactoryGirl.create(:answer)
end
