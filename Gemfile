source 'https://rubygems.org'

ruby '2.1.5' # TODO Rails 3.2 doesn't officially support Ruby 2.2 yet

# TODO bump, synch base files, add asset group gems
gem 'rails', '~> 3.2.21'

# TODO can likely be removed after Rails 4.x since it's bundled by default
gem 'strong_parameters'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'cancancan', '~> 1.10.0' # TODO latest? yes

gem 'devise', '~> 3.5.1' # TODO latest? yes

gem 'nested_form', '~> 0.3.2' # TODO latest? yes

# Utilities
# Validate time/date columns (jc = fork with Rails 4.x compatibility)
gem 'jc-validates_timeliness', '~> 3.1.1' # TODO latest? yes

# Notify on exception via email
gem 'exception_notification', '~> 4.0.1 ' # TODO latest? yes

# TODO bump, watch for breaking changes
gem 'paperclip', '~> 4.2.1' # TODO latest? yes

# For record versioning and audits
gem 'paper_trail', '~> 3.0.8' # TODO latest? yes, but 4.0 is at RC1
  
# TODO currently works with ActiveRecord 3.0.5 through 4.0.1
#   See https://github.com/appfolio/store_base_sti_class/pull/13
gem 'store_base_sti_class', '~> 0.3.0' # TODO latest? yes

# TODO Still necessary?
gem 'uuidtools', '~> 2.1.5' # TODO latest? yes

gem 'will_paginate', '~> 3.0.7' # TODO latest? yes

# TODO key functionality, bump version, watch for breaking changes
# TODO may need to fork upgrade for Rails 4
gem 'surveyor', '~> 0.22.0'# TODO latest? 1.4.0, last updated 25 Apr 2013

# Deploy with Capistrano
# TODO update for Capistrano v3 syntax, and move to development group
gem 'capistrano',     :require => false # We need it to be installed, but it's
gem 'capistrano-ext', :require => false # not a runtime dependency
gem 'rvm-capistrano', :require => false

gem 'pg'

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
end

group :test do
  # TODO switch to shoulda matchers?
  gem 'accept_values_for', '~> 0.7' # latest? yes
  
  # Make sure this gets upgraded to use latest version of Firefox
  gem 'capybara', '~> 2.4' # TODO latest? yes
  gem 'capybara-firebug', '~> 2.1' # TODO latest? yes
  
  # TODO bump version, watch for breaking changes
  gem 'cucumber-rails', '~> 1.3.0', :require => false # TODO latest? 1.4.2

  gem 'database_cleaner', '~> 1.4' # TODO latest? yes
    
  # Easily test email in RSpec, Cucumber, and MiniTest
  # TODO could this be replaced with native assertions and matchers?
  gem 'email_spec', '~> 1.2.1' # TODO latest? 1.6.0
    
  # A simple DSL extending Capybara
  # TODO verify still active and usable
  gem 'prickle', '~> 0.0.6' # TODO latest? 0.1.0, last updated March 14, 2013

  gem 'launchy', '~> 2.4.3' # TODO latest?
end

group :test, :development do
  gem 'byebug'
  
  # TODO Update application.rb and verify syntax of factory files
  gem 'factory_girl_rails', '~> 3.2' # TODO latest? 4.5.0
  
  gem 'ffaker', '~> 2.0' # TODO latest? yes
  
  # TODO fix deprecation errors, then move to 3.x
  gem 'rspec-rails', '~> 2.99' # TODO latest? 3.2.1
end
