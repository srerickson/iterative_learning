require "spec_helper"

describe "Generation" do
  before :each do
    @experiment = Experiment.new()
    @condition = @experiment.conditions.new()
    @chain = @condition.chains.new()
    @generation = @chain.generations.new()
  end

  it "should be valid with correct values" do
    expect(@generation).to be_valid
  end


end