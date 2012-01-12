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

After('@pause_on_fail') do |scenario|
  if scenario.respond_to?(:status) && scenario.status == :failed
    print "Step Failed. Press Return to close browser"
    STDIN.getc
  end
end