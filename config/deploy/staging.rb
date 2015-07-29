set :branch, 'new_staging'
set :rvm_ruby_version, '2.2.2@wiseguide'
set :passenger_rvm_ruby_version, '2.2.2@passenger'
set :deploy_to, '/home/deploy/rails/wiseguide'
set :default_env, { "RAILS_RELATIVE_URL_ROOT" => "/wiseguide" }

# capistrano-rails directives
set :rails_env, 'staging'
set :assets_roles, [:web, :app]
set :migration_role, [:db]
set :conditionally_migrate, true

server 'staging.rideconnection.org', roles: [:app, :web, :db], user: 'deploy'
