source 'https://rubygems.org'

# TODO bump to 2.2
ruby '1.9.3'

# TODO bump, synch base files, add asset group gems
gem 'rails', '3.2.21'

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

# TODO switch to cancancan
# TODO bump, add pessimistic operator, watch for breaking changes
gem "cancan"

# TODO bump, add pessimistic operator, watch for breaking changes
gem "devise"

# Utilities
# TODO replace with (jc-)validates_timeliness? 
# TODO verify still active and usable, add pessimistic operator
gem "date_validator"

# TODO verify still active and usable, use gem if possible
gem "exception_notification", 
  :git => "git://github.com/rails/exception_notification.git", 
  :require => "exception_notifier"

# TODO verify neccessity, bump, watching for breaking changes
gem "formtastic", "~> 1.2.4"

# TODO Do we use this anywhere? If so: bump
gem "haml", "~> 3.1.3"

# TODO bump, watch for breaking changes
gem "paperclip", "~> 3.0.2"

# Using userstamp from git for now, because 2.0.2 (Rails 3.2 compatible) has
# not been uploaded to rubygems as of this writing.
# TODO switch to paper_trail
gem "userstamp",
  :git => "git://github.com/delynn/userstamp.git",
  :ref => "777633a"
  
# TODO verify neccessity, bump version, add pessimistic operator
gem 'store_base_sti_class'

# TODO verify neccessity, bump version, add pessimistic operator
gem "uuidtools"

# TODO bump, add pessimistic operator
gem "will_paginate", "~> 3.0.3"

# For PDF Generation
# TODO verify still active and usable, use gem if possible
gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git",
  :ref => "d06f81b", :submodules => true
gem "pdf-reader", :require => "pdf/reader"
gem "Ascii85", :require => "ascii85"

# TODO verify still active and usable
gem "surveyor", "~> 0.22.0"

# Deploy with Capistrano
# TODO update for Capistrano v3 syntax, and move to development group
gem "capistrano",     :require => false # We need it to be installed, but it's
gem "capistrano-ext", :require => false # not a runtime dependency
gem "rvm-capistrano", :require => false

gem "pg"

group :development do
  # TODO still necessary?
  gem "launchy"
  
  # TODO switch to Spring
  gem "spork-rails"
  
  # TODO drop for latest webrick?
  gem "thin"
end

group :test do
  # TODO switch to shoulda matchers?
  gem "accept_values_for", "~> 0.4.3"
  
  # Make sure this gets upgraded to use latest version of Firefox
  gem "capybara-firebug"
  
  gem "cucumber"
  gem "cucumber-rails", :require => false
  
  gem "database_cleaner"
  
  # TODO can this be replaced with native assertions and matchers?
  gem "email_spec"
  
  # TODO verify still active and usable
  gem "pdf-inspector", :require => "pdf/inspector"
  
  # TODO verify still active and usable
  gem "prickle"
end

group :development, :test do
  # TODO Switch to byebug
  gem "debugger"
  
  # TODO Update application.rb and verify syntax of factory files
  gem "factory_girl_rails"
  
  # TODO switch to ffaker?
  gem "faker"
  
  # TODO Upgrade to 2.99, make sure deprecated options are fixed, then move to 3
  gem "rspec-rails"

  # Do we need this for anything? We should really be running against PG
  gem "sqlite3-ruby", :require => "sqlite3"
end
