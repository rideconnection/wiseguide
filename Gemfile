source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '~> 4.0.13'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'cancancan', '~> 1.10.0'

gem 'devise', '~> 3.5.1'

gem 'nested_form', '~> 0.3.2'

# Validate time/date columns (jc = fork with Rails 4.x compatibility)
gem 'jc-validates_timeliness', '~> 3.1.1'

# Notify on exception via email
gem 'exception_notification', '~> 4.0.1 '

gem 'paperclip', '~> 4.2.1'

# For record versioning and audits
gem 'paper_trail', '~> 3.0.8' # TODO latest? yes, but 4.0 is at RC1
  
# TODO currently works with ActiveRecord 3.0.5 through 4.0.1
#   See https://github.com/appfolio/store_base_sti_class/pull/13
gem 'store_base_sti_class', '~> 0.3.0'

# TODO Still necessary?
gem 'uuidtools', '~> 2.1.5'

gem 'will_paginate', '~> 3.0.7'

# TODO key functionality, bump version, watch for breaking changes
# TODO Only compatible with Rails <= 4.0. Pending pull requests for 4.1
# TODO latest? maybe? Vendoring from master as the 1.4 gem doesn't include support for Rails 4.0
gem 'surveyor', :git => "git://github.com/NUBIC/surveyor.git",
  :ref => "d4fe8df2586ba26126bac3c4b3498e67ba813baf"

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
  gem 'capybara', '~> 2.4'
  gem 'capybara-firebug', '~> 2.1'
  
  gem 'cucumber-rails', '~> 1.4.2', :require => false

  gem 'database_cleaner', '~> 1.4'
    
  # Easily test email in RSpec, Cucumber, and MiniTest
  # TODO could this be replaced with native assertions and matchers?
  gem 'email_spec', '~> 1.6.0'
  
  gem 'launchy', '~> 2.4.3'
end

group :test, :development do
  gem 'byebug'
  
  gem 'factory_girl_rails', '~> 4.5'
  
  gem 'ffaker', '~> 2.0'
  
  gem 'rspec-rails', '~> 3.1.0' # TODO latest? 3.2, Waiting on PR #1388/#1389 to be merged
end
