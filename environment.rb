$:.unshift("./app","./app/api","./app/serializers","./lib")

ENV["IL_SECRET"] ||= "12345f9ashf8aj4jf84j4jkkof9djnxbxvbfw5261klzlsldkhe73652fgggatq54242tys78d77386354lkjhuyrtsbgcerwrq765897lkkjhpou"
ENV["RACK_ENV"] ||= "development"
ENV["BASE_URL"] ||= "https://il.thebig.computer"


VERSION = '0.1'

require 'rubygems'
require 'grape'
require 'grape-entity'
require 'hashie_rails'
require 'sqlite3'
require 'active_record'
require 'require_all'

### ActiveRecord config

config = ENV['DATABASE_URL'] || {
    adapter: 'sqlite3',
    database: "experiment_data.db",
  }

ActiveRecord::Base.establish_connection(config)



### Logging 

require 'lib/il/iterative_learning'
require 'lib/il/function_learning'
require 'lib/il/mturk'

# require_all 'app/uploaders'
require_all 'app/models'
# require_all 'app/serializers'

require 'api/api'