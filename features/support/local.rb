FactoryGirl.reload

ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails'
require 'capybara/firebug'
require 'email_spec'
require 'email_spec/cucumber'
require 'selenium-webdriver'
require 'selenium/webdriver/firefox/bridge'
require 'rack/handler/webrick'
require 'prickle/capybara'
require 'paper_trail/frameworks/cucumber'

# We're going to use our custom factory_girl step definition file instead
# require 'factory_girl/step_definitions'

World(Capybara::DSL)
World(Prickle::Capybara)

# Transaction is MUCH faster than truncation. However, cucumber-rails has to
# patch ActiveRecord to use the same database connection in all threads. This
# means there is a chance failures will occur in multithreaded scenarios, but
# I don't think this will happen for WiseGuide.  If we see random failures, we
# should try commenting this out.
Cucumber::Rails::Database.javascript_strategy = :transaction
