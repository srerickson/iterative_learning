$:.unshift("./")
require 'environment.rb'

RSpec.configure do |config|
  config.before(:each) do
    Experiment.build_from_config('spec/experiments.yml')
    @experiment = Experiment.find_by_name('spec_experiment1')

    @sample_positive = IterativeLearning::FunctionLearning.positive(10)
    @sample_negative = IterativeLearning::FunctionLearning.negative(10)
  end


  config.after :each do 
    @experiment.destroy
  end

end