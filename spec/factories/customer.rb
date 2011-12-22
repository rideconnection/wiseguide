# Some street names to choose from
STREET_NAMES = [
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

# Create a customer with some randomized data
Factory.define :customer do |f|
  f.first_name     { Faker::Name.first_name }
  f.last_name      { Faker::Name.last_name }
  f.email          { Faker::Internet.email }
  f.ethnicity_id   { Ethnicity.all.sample.id }
  f.birth_date     { "#{1930+rand(50)}-#{1+rand(12)}-#{1+rand(28)}" }
  f.gender         { ALL_GENDERS.sample[1] }
  f.phone_number_1 { "503-555-#{1000+rand(9000)}" }
  f.address        { "#{1+rand(500)} #{STREET_NAMES.sample}" }
  f.city           'Portland'
  f.state          'OR'
  f.zip            { "9720#{1+rand(9)}" }
  f.county         { County.all.sample.name }
end
