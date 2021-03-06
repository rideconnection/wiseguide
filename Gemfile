source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '~> 4.2.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'cancancan', '~> 1.10.0'

gem 'devise', '~> 3.5'

gem 'nested_form', '~> 0.3.2'

# Validate time/date columns (jc = fork with Rails 4.x compatibility)
gem 'jc-validates_timeliness', '~> 3.1.1'

# Notify on exception via email
gem 'exception_notification', '~> 4.0.1 '

gem 'paperclip', '~> 4.2.1'

# For record versioning and audits
gem 'paper_trail', '~> 3.0' # TODO latest? yes, but 4.0 is at RC1
  
# TODO currently works with ActiveRecord 3.0.5 through 4.0.1
#   See https://github.com/appfolio/store_base_sti_class/pull/13
gem 'store_base_sti_class', '~> 0.3'

# TODO Still necessary?
gem 'uuidtools', '~> 2.1.5'

gem 'will_paginate', '~> 3.0.7'

# TODO key functionality, bump version, watch for breaking changes
# TODO Only compatible with Rails <= 4.0. Pending pull requests for 4.1
# TODO latest? maybe? Vendoring from master as the 1.4 gem doesn't include support for Rails 4.0
gem 'surveyor', :git => "git://github.com/NUBIC/surveyor.git",
  :ref => "d4fe8df2586ba26126bac3c4b3498e67ba813baf"

# Extends the runway for the current version of Surveyor to work
# with Rails 4.2
gem 'protected_attributes'

gem 'pg'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
  
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-secrets-yml', '~> 1.0', require: false
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
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  
  gem 'factory_girl_rails', '~> 4.5'
  
  gem 'ffaker', '~> 2.0'
  
  gem 'rspec-rails', '~> 3.2.0' # TODO latest? yes
end
