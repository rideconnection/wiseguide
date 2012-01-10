Before do
  # This seems to cause more problems then it solves
  # DatabaseCleaner.start
  
  load("#{Rails.root}/db/seeds.rb")

  # Create users that will be used in the scenarios
  Factory.create(:admin)
  Factory.create(:trainer)
end

After do |scenario|
  # This seems to cause more problems then it solves
  # DatabaseCleaner.clean
end
