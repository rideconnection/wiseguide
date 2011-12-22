namespace :db do
  namespace :sandbox do
    require "#{Rails.root}/db/sandbox.rb"
    desc "Load sandbox data into database."
    task :load do
      load_sandbox_data
    end
  end
end
