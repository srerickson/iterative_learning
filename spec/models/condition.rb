require "spec_helper"

describe "Condition" do
  before :each do
    rebuild_experiment
    @experiment = Experiment.first
    @condition = @experiment.conditions.first
  end

  it "should be valid with correct values" do
    expect(@condition).to be_valid
  end

  it "should call experiments's update_experiment when update_experiment is called" do
    expect(@condition.experiment).to receive(:update_experiment).with(123)
    @condition.update_experiment(123)
  end

  it "should call prepare on all chains when prepare is called" do
    @condition.chains.each{ |c| expect(c).to receive(:prepare) }
    @condition.prepare
  end


end