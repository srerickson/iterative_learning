require "spec_helper"

describe "Chain" do
  before :each do
    @condition = @experiment.conditions.first
    @chain = @condition.chains.new()
  end

  it "should be valid with correct values" do
    expect(@chain).to be_valid
  end


end