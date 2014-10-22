require "spec_helper"

describe "Chain" do
  before :each do
    @experiment = Experiment.new()
    @condition = @experiment.conditions.new()
    @chain = @condition.chains.new()
  end

  it "should be valid with correct values" do
    expect(@chain).to be_valid
  end


end