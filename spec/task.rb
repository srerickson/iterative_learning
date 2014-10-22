require "spec_helper"

describe "Task" do
  before :each do
    @experiment = Experiment.new()
    @condition = @experiment.conditions.new()
    @chain = @condition.chains.new()
    @generation = @chain.generations.new()
    @task = @generation.tasks.new()
  end

  it "should be valid with correct values" do
    expect(@task).to be_valid
  end


end