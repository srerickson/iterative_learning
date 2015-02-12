require "spec_helper"

describe "Task" do
  before :each do
    rebuild_experiment
    @experiment = Experiment.first
    @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
  end

  it "should be valid with correct values" do
    expect(@task).to be_valid
  end

  it "has response_fitness method" do
    @task.response_values = sample_positive
    expect(@task.response_fitness).to be_an(Integer)
  end


end