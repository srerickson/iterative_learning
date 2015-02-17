require "spec_helper"

describe "Experiment" do
  
  before :each do
    @experiment = rebuild_experiment("spec_experiment1")
  end

  it "should be valid with correct values" do
    expect(@experiment).to be_valid
  end

  it "should call prepare on all conditions when prepare is called" do
    @experiment.conditions.each{ |c| expect(c).to receive(:prepare) }
    @experiment.prepare
  end

end