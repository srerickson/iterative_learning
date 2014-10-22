$:.unshift("./app","./app/api","./app/serializers","./lib")

ENV["IL_SECRET"] ||= "12345"
ENV["RACK_ENV"] ||= "development"

VERSION = '0.1'

require 'rubygems'
require 'grape'
require 'hashie_rails'
require 'pg'
require 'active_record'
require 'require_all'

### ActiveRecord config

config = ENV['DATABASE_URL'] || {
    adapter: 'postgresql',
    host: "localhost",
    database: "iterative_learning",
    encoding: 'utf8'
  }

ActiveRecord::Base.establish_connection(config)



### Logging 

if ENV['RACK_ENV'] == "development"
  ActiveRecord::Base.logger = Logger.new(STDOUT) 
end 


# require_all 'app/uploaders'
require_all 'app/models'
# require_all 'app/serializers'

require 'api'