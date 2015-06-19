# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

['In Progress', 'Successful', 'Unsuccessful', 'Incomplete', 'Exited'].each do |d|
  TrainingKaseDisposition.find_or_create_by(name: d)
end

['In Progress', 'Successful', 'Unsuccessful', 'Incomplete', 'Exited'].each do |d|
  CoachingKaseDisposition.find_or_create_by(name: d)
end

['In Progress', 'Substantiated', 'Unsubstantiated', 'Indeterminable', 'Completed'].each do |d|
  CustomerServiceKaseDisposition.find_or_create_by(name: d)
end

['STF','JARC Clackamas','JARC Multnomah','JARC Washington'].each do |fs|
  FundingSource.find_or_create_by(name: fs)
end

['Clackamas', 'Multnomah', 'Washington'].each do |county|
  County.find_or_create_by(name: county)
end

['Caucasian','African American','Asian','Asian Indian','Chinese','Filipino','Japanese','Korean','Vietnamese','Pacific Islander','American Indian/Alaska Native','Native Hawaiian','Guamanian or Chamorro','Samoan','Russian','Unknown','Refused','Other','Hispanic'].each do |e|
  Ethnicity.find_or_create_by(name: e)
end 

['Medical','Life-sustaining Medical','Personal/Support Services','Shopping','School/Work','Volunteer Work','Recreation','Nutrition'].each do |tr|
  TripReason.find_or_create_by(name: tr)
end

['Initial Interview','Route & Scout','Travel Training','Trainee Shadow','Honored Citizen Card Requested','Liability Waiver Signed'].each do |et|
  EventType.find_or_create_by(name: et)
end

CSV.foreach(File.join(Rails.root,'db','seeds','impairments.csv'), headers: true) do |r|
  Impairment.find_or_create_by(name: r['name'])
end

CSV.foreach(File.join(Rails.root,'db','seeds','routes.csv'), headers: true) do |r|
  Route.find_or_create_by(name: r['name'])
end

CSV.foreach(File.join(Rails.root,'db','seeds','referral_types.csv'), headers: true) do |r|
  ReferralType.find_or_create_by(name: r['name'])
end

Organization.find_or_create_by(name: 'Ride Connection') do |o|
  o.organization_type = Organization::ORGANIZATION_TYPES[:staff][:id]
end

["Application Pending", "Conditional Eligibility", "Never Applied", "Not Eligible", "Out of ADA Area", "Service Terminated", "Temporary Conditional Eligibility", "Unconditional Eligibility"].each do |status|
  AdaServiceEligibilityStatus.find_or_create_by(name: status)
end