ENV["RACK_ENV"] = "test"
$:.unshift("./")
require 'environment.rb'
require "rack/test"
require 'rake'

module Helpers
  def rebuild_experiment
    Rake.application['il:rebuild'].invoke(nil,'spec/experiments.yml')
    Rake.application['il:rebuild'].reenable
  end

  def sample_positive
    IterativeLearning::FunctionLearning.positive(10)
  end

  def sample_negative
    IterativeLearning::FunctionLearning.negative(10)
  end

end


RSpec.configure do |config|
  Rake.application.init
  Rake.application.load_rakefile
  config.include Helpers
end