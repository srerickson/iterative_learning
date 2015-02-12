$:.unshift("./app","./app/api","./app/serializers","./lib")

VERSION = '0.1'

require 'rubygems'
require 'bundler/setup'

require 'grape'
require 'grape-entity'
require 'hashie_rails'
require 'sqlite3'
require 'active_record'
require 'require_all'


### Read config/settings.yml
settings = YAML.load_file(File.expand_path("../config/settings.yml",__FILE__))

ENV["RACK_ENV"]  ||= settings['environment']
ENV["IL_SECRET"] ||= settings['secret']
ENV["BASE_URL"]  ||= settings[ENV['RACK_ENV']]['base_url']


### ActiveRecord config
ActiveRecord::Base.establish_connection(settings[ENV['RACK_ENV']]['database'])

# load the application 
require 'lib/il/iterative_learning'
require 'lib/il/function_learning'
require 'lib/il/mturk'
require_all 'app/models'
require 'api/api'