source "http://rubygems.org"

# Framework
gem "rails", "~> 3.0.11"
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
gem "paperclip"
gem "userstamp"
gem "will_paginate", "3.0.pre2"

# For PDF Generation
gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git", :tag => '0.12.0', :submodules => true
gem "pdf-reader", :require => "pdf/reader"
gem "Ascii85", :require => "ascii85"

# Note: We are including a heavily customized version of Surveyor based off on an old fork
gem "surveyor", :git => "git://github.com/openplans/surveyor.git", 
  :branch => "rails3"

# Deploy with Capistrano
gem "capistrano",     :require => false # We need it to be installed, but it's
gem "capistrano-ext", :require => false # not a runtime dependency

group :production, :staging do
  gem "pg"
end

group :development do
  gem "cucumber-rails"
  gem "rspec-rails"
  gem "spork"
  gem "launchy"
end

group :development, :test do
  gem "accept_values_for", "~> 0.4.3"
  gem "capybara-firebug"
  gem "cucumber"
  gem "database_cleaner"
  gem "pdf-inspector", :require => "pdf/inspector"
  gem "ruby-debug19", :require => "ruby-debug"
  gem "sqlite3-ruby", :require => "sqlite3"
  gem 'email_spec'
end

group :development, :test, :staging do
  gem "factory_girl_rails"
  gem "faker"
end
