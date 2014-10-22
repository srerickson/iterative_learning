require "spec_helper"

describe "Condition" do
  before :each do
    @experiment = Experiment.new()
    @condition = @experiment.conditions.new()
  end

  it "should be valid with correct values" do
    expect(@condition).to be_valid
  end


end