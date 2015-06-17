require "spec_helper"

describe "Task" do
  before :each do
    @experiment = rebuild_experiment("spec_experiment1")
    @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
  end

  it "should be valid with correct values" do
    expect(@task).to be_valid
  end

  it "should call generation's update_experiment when update_experiment is called" do
    expect(@task.generation).to receive(:update_experiment).with(@task)
    @task.update_experiment
  end


  describe "#response_fitness" do
    it "returns an integer" do
      @task.response_values = sample_positive
      expect(@task.response_fitness).to be_an(Integer)
    end

    it "calls fitness on parent chain" do
      @task.response_values = sample_positive
      parent_chain = @task.generation.chain
      expect(parent_chain).to receive(:fitness).with(@task.response_values)
      @task.response_fitness
    end

  end




end