Dir.glob('lib/tasks/*.rake').each { |r| import r }


require 'fileutils'

task :environment do 
  puts "loading environment ... "
  $:.unshift('./') 
  require 'environment.rb'
end


desc "API Routes"
task routes: :environment do
  IterativeLearning::API.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path
    puts "     #{method} #{path}"
  end
end


namespace :db do

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end


  desc "Rollback the database"
  task(:rollback => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    steps = ENV["STEPS"].to_i == 0 ? 1 : ENV["STEPS"].to_i
    ActiveRecord::Migrator.rollback("db/migrate", steps)
  end



  desc "create an ActiveRecord migration in ./db/migrate"
  task(:create_migration => :environment) do
    name = ENV['NAME']
    abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

    migrations_dir = File.join("db", "migrate")
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S") 
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end

 

end