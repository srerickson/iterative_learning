require "spec_helper"

describe "Chain" do
  
  before :each do
    @experiment = rebuild_experiment("spec_experiment1")
    @chain = @experiment.conditions.first.chains.first
  end

  it "should be valid with correct values" do
    expect(@chain).to be_valid
  end

  it "should call conditions's update_experiment when update_experiment is called" do
    expect(@chain.condition).to receive(:update_experiment).with(123)
    @chain.update_experiment(123)
  end

  it "should call prepare on first generation when prepare is called" do
    expect(@chain.first_generation).to receive(:prepare).with(@chain.condition.start_values)
    @chain.prepare
  end

end