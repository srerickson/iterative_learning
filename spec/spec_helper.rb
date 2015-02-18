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