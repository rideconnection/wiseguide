set :branch, "master"
set :rvm_ruby_string, '1.9.2-p290@wiseguide'
role :web, "184.154.158.74"
role :app, "184.154.158.74"
role :db,  "184.154.158.74", :primary => true # This is where Rails migrations will run

