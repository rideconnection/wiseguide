source 'https://rubygems.org'

ruby '2.1.5' # TODO Rails 3.2 doesn't officially support Ruby 2.2 yet

# TODO bump, synch base files, add asset group gems
gem 'rails', '~> 3.2.21'

# Setup SP on Rails 3.2, can likely be removed after Rails 4.x
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

# TODO bump, watch for breaking changes
gem 'devise', '~> 2.0.6' # TODO latest? 3.4.1

# Utilities
# Validate time/date columns (jc = fork with Rails 4.x compatibility)
gem 'jc-validates_timeliness', '~> 3.1.1' # TODO latest? yes

# Notify on exception via email
gem 'exception_notification', '~> 4.0.1 ', group: :production # TODO latest? yes

# Form builder with semantic markup
# TODO verify neccessity, bump, watching for breaking changes
gem 'formtastic', '~> 1.2.4' # TODO latest? 3.1.3

# TODO Do we use this anywhere? There aren't any HAML files. If so: bump
# gem 'haml', '~> 3.1.3'

# TODO bump, watch for breaking changes
gem 'paperclip', '~> 3.0.4' # TODO latest? 4.2.1

# Using userstamp from git for now, because 2.0.2 (Rails 3.2 compatible) has
# not been uploaded to rubygems as of this writing.
# TODO switch to paper_trail
gem 'userstamp',
  :git => 'git://github.com/delynn/userstamp.git',
  :ref => '777633a'
  
# TODO bump version, watch for breaking changes
gem 'store_base_sti_class', '~> 0.0.2' # TODO latest? 0.3.0

# TODO bump version, add pessimistic operator
gem 'uuidtools', '~> 2.1.5' # TODO latest? yes

# TODO bump, add pessimistic operator
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
  gem 'capybara', '~> 1.1' # TODO latest? 2.4.4
  gem 'capybara-firebug', '~> 1.1' # TODO latest? 2.1.0
  
  # TODO bump version, watch for breaking changes
  gem 'cucumber-rails', '~> 1.3.0', :require => false # TODO latest? 1.4.2

  # TODO bump version, watch for breaking changes
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
