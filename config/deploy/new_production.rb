set :branch, 'rails-upgrade'
set :rvm_ruby_version, '2.1.5@wiseguide'
set :passenger_rvm_ruby_version, '2.2.1@passenger'
set :deploy_to, '/home/deploy/rails/wiseguide'
set :rails_env, 'production'
set :default_env, { "RAILS_RELATIVE_URL_ROOT" => "/wiseguide" }
server 'apps2.rideconnection.org', roles: [:app, :web, :db], user: 'deploy'
