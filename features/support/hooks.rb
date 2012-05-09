Before do
  load("#{Rails.root}/db/seeds.rb")

  # Create users that will be used in the scenarios
  #FactoryGirl.create(:admin)
  #FactoryGirl.create(:trainer)
end

# DatabaseCleaner is invoked by cucumber-rails env.rb, so no cleanup is
# needed here.  Uncomment if any post-scenario logic is needed.
#After do |scenario|
#end

After('@pause_on_fail') do |scenario|
  if scenario.respond_to?(:status) && scenario.status == :failed
    print "Step Failed. Press Return to close browser"
    STDIN.getc
  end
end
