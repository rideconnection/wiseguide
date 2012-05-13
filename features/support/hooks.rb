Before do
  load("#{Rails.root}/db/seeds.rb")
end

After('@pause_on_fail') do |scenario|
  if scenario.respond_to?(:status) && scenario.status == :failed
    print "Step Failed. Press Return to close browser"
    STDIN.getc
  end
end
