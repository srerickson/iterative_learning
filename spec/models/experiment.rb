require "spec_helper"

describe "Experiment" do
  
  before :each do
    rebuild_experiment
    @experiment = Experiment.first
  end

  it "should be valid with correct values" do
    expect(@experiment).to be_valid
  end


end