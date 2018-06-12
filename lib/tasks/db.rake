# lib/tasks/db.rake
namespace :db do

    desc "Dumps the database to db/app_name.dump"
    task :dump => :environment do
      cmd = nil
      with_config do |app, host, db, user|
        cmd = "pg_dump --host localhost --format=c #{db} > #{Rails.root}/db/#{app}.dump"
      end
      puts cmd
      exec cmd
    end

    def with_config
        yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
      end
end