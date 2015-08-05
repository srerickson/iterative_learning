ENV["IL_ENV"] = "test"
$:.unshift("./")
require 'environment.rb'
require "rack/test"
require 'rake'

module Helpers
  def rebuild_experiment(name)
    Rake.application['il:remove'].invoke(name)
    Rake.application['il:remove'].reenable
    Rake.application['il:build'].invoke("spec/experiments/#{name}.yml")
    Rake.application['il:build'].reenable
    Experiment.find_by_name(name)
  end

  def sample_positive(num=10)
    IterativeLearning::FunctionLearning.positive(num)
  end

  def sample_negative(num=10)
    IterativeLearning::FunctionLearning.negative(num)
  end

end


RSpec.configure do |config|
  Rake.application.init
  Rake.application.load_rakefile
  config.include Helpers

  config.before(:all) do
    Rake.application['db:migrate'].invoke
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = false 
  end

  config.after(:all) do
    puts "clearing experiments"
    Experiment.all.each{|e| e.destroy}
  end

end