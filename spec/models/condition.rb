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


end