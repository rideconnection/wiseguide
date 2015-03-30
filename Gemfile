source 'https://rubygems.org'

# TODO bump to 2.2
ruby '1.9.3'

# TODO bump, synch base files, add asset group gems
gem 'rails', '~> 3.2.21'

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

# TODO switch to cancancan 1.10.1
# TODO bump, watch for breaking changes
gem 'cancan', '~> 1.6.7' # TODO latest? 1.6.10

# TODO bump, watch for breaking changes
gem 'devise', '~> 2.0.4' # TODO latest? 3.4.1

# Utilities
# Validate time/date columns (jc = fork with Rails 4.x compatibility)
gem 'jc-validates_timeliness', '~> 3.1.1' # TODO latest? yes

# Notify on exception via email
# TODO verify config syntax
gem 'exception_notification', '~> 4.0.1 ', group: :production # TODO latest? yes

# Form builder with semantic markup
# TODO verify neccessity, bump, watching for breaking changes
gem 'formtastic', '~> 1.2.4' # TODO latest? 3.1.3

# TODO Do we use this anywhere? There aren't any HAML files. If so: bump
# gem 'haml', '~> 3.1.3'

# TODO bump, watch for breaking changes
gem 'paperclip', '~> 3.0.2' # TODO latest? 4.2.1

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

# For PDF Generation
# TODO bump, watching for breaking changes
# NOTE 1.0.0.rc2 < ref d06f81b > 1.0.0.rc1
gem 'prawn', :git => 'git://github.com/prawnpdf/prawn.git',
  :ref => 'd06f81b', :submodules => true # TODO latest? 2.0.1

# TODO Are these two gems still necessary?, If so: bump
gem 'pdf-reader', '~> 1.1.0', :require => 'pdf/reader' # TODO latest? 1.3.3, last updated 7 Apr 2013
gem 'Ascii85', '~> 1.0.2', :require => 'ascii85' # TODO last updated 16 Sep 2012

# TODO verify still usable, bump version, watch for breaking changes
gem 'surveyor', '~> 0.22.0'# TODO latest? 1.4.0, last updated 25 Apr 2013

# Deploy with Capistrano
# TODO update for Capistrano v3 syntax, and move to development group
gem 'capistrano',     :require => false # We need it to be installed, but it's
gem 'capistrano-ext', :require => false # not a runtime dependency
gem 'rvm-capistrano', :require => false

gem 'pg'

group :development do
  # TODO still necessary?
  gem 'launchy', '~> 2.1'
  
  # TODO switch to Spring
  gem 'spork-rails', '~> 3.2'
end

group :test do
  # TODO switch to shoulda matchers?
  gem 'accept_values_for', '~> 0.4.3' # latest? 0.7.2
  
  # Make sure this gets upgraded to use latest version of Firefox
  gem 'capybara', '~> 1.1' # TODO latest? 2.4.4
  gem 'capybara-firebug', '~> 1.1' # TODO latest? 2.1.0
  
  gem 'cucumber', '~> 1.1' # TODO latest? 2.0
  gem 'cucumber-rails', '~> 1.3.0' # TODO latest? 1.4.2
    
  # Easily test email in RSpec, Cucumber, and MiniTest
  # TODO could this be replaced with native assertions and matchers?
  gem 'email_spec', '~> 1.2.1' # TODO latest? 1.6.0
  
  # Provides a number tools for use in testing PDF output
  # TODO verify still active and usable
  gem 'pdf-inspector', '~> 1.0.1', :require => 'pdf/inspector' # TODO latest? 1.2.0
  
  # A simple DSL extending Capybara
  # TODO verify still active and usable
  gem 'prickle', '~> 0.0.6' # TODO latest? 0.1.0, last updated March 14, 2013
end

group :test, :development do
  # TODO Switch to byebug once we are on Ruby >= 2.0.0
  gem 'debugger'
  
  # TODO Update application.rb and verify syntax of factory files
  gem 'factory_girl_rails', '~> 3.2' # TODO latest? 4.5.0
  
  # TODO switch to ffaker?
  gem 'faker', '~> 1.4'
  
  # TODO Upgrade Rspec to 2.99, fix deprecation errors, then move to 3.x
  gem 'rspec-rails', '~> 2.10' # TODO latest? 3.2.1
  
  # TODO bump version, watch for breaking changes
  gem 'database_cleaner', '~> 0.4' # TODO latest? 1.4.1
end
