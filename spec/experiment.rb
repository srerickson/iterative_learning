require "spec_helper"

describe "Experiment" do
  before :each do
    @experiment = Experiment.new()
  end

  it "should be valid with correct values" do
    expect(@experiment).to be_valid
  end


end