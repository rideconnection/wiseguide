if Rails.env == 'development'
  namespace :db do
    namespace :sandbox do
      desc "Load sandbox data into database."
      task :load do
        require "#{Rails.root}/db/sandbox.rb"
        load_sandbox_data
      end
    end
  end
end
