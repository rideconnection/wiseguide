set :branch, 'rails-upgrade'
set :rvm_ruby_version, '2.2.2@wiseguide'
set :passenger_rvm_ruby_version, '2.2.1@passenger'
set :deploy_to, '/home/deploy/rails/wiseguide'
set :default_env, { "RAILS_RELATIVE_URL_ROOT" => "/wiseguide" }

# capistrano-rails directives
set :rails_env, 'production'
set :assets_roles, [:web, :app]
set :migration_role, [:db]
set :conditionally_migrate, true
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

server 'apps2.rideconnection.org', roles: [:app, :web, :db], user: 'deploy'
