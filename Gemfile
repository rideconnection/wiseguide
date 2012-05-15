source "http://rubygems.org"

# Framework
gem "rails", "~> 3.2.0"
gem "rake"

# Authentication and authorization
gem "cancan"
gem "devise"

# Utilities
gem "date_validator"
gem "exception_notification", 
  :git => "git://github.com/rails/exception_notification.git", 
  :require => "exception_notifier"
gem "formtastic", "~> 1.2.4"
gem "haml", "~> 3.1.3"
gem "jquery-rails", ">= 0.2.6"
gem "paperclip", "~> 3.0.2"
# Using userstamp from git for now, because 2.0.2 (Rails 3.2 compatible) has
# not been uploaded to rubygems as of this writing.
gem "userstamp",
  :git => "git://github.com/delynn/userstamp.git",
  :ref => "777633a"
gem "uuidtools"
gem "will_paginate", "~> 3.0.3"

# For PDF Generation
gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git",
  :ref => "d06f81b", :submodules => true
gem "pdf-reader", :require => "pdf/reader"
gem "Ascii85", :require => "ascii85"

gem "surveyor", "~> 0.22.0"

# Deploy with Capistrano
gem "capistrano",     :require => false # We need it to be installed, but it's
gem "capistrano-ext", :require => false # not a runtime dependency
gem "rvm-capistrano", :require => false

group :production, :staging do
  gem "pg"
end

group :development do
  gem "launchy"
  gem "spork-rails"
  gem "thin"
end

group :test do
  gem "accept_values_for", "~> 0.4.3"
  gem "capybara-firebug"
  gem "cucumber"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "debugger"
  gem "email_spec"
  gem "factory_girl_rails"
  gem "faker"
  gem "pdf-inspector", :require => "pdf/inspector"
  gem "prickle"
end

group :development, :test do
  gem "debugger"
  gem "rspec-rails"
  gem "sqlite3-ruby", :require => "sqlite3"
end
