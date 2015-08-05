$:.unshift("./app","./app/api","./app/serializers","./lib")

VERSION = '0.2'

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

ENV["IL_ENV"]      ||= settings['environment']
ENV["IL_SECRET"]   ||= settings['secret']
ENV["BASE_URL"]    ||= settings[ENV['IL_ENV']]['base_url']
ENV["ALERT_EMAIL"] ||= settings['alert_email']


### ActiveRecord config
ActiveRecord::Base.establish_connection(settings[ENV['IL_ENV']]['database'])

# load the application
require 'lib/il/iterative_learning'
require 'lib/il/function_learning'
require 'lib/il/mturk'
require_all 'app/models'
require 'api/api'