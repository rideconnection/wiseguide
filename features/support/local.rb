Spork.each_run do
  FactoryGirl.reload
end

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails'
  require 'capybara/firebug'
  require 'email_spec'
  require 'email_spec/cucumber'
  require 'selenium-webdriver'
  require 'selenium/webdriver/firefox/bridge'
  require 'rack/handler/webrick'
  
  # We're going to use our custom factory_girl step definition file instead
  # require 'factory_girl/step_definitions'
end
