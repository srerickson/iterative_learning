require "spec_helper"

describe "Condition" do
  before :each do
    @experiment = rebuild_experiment("spec_experiment1")
    @condition = @experiment.conditions.first
    @last_condition = @experiment.conditions.last
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

  it "should have start_values if condition-wide values are defined" do
    expect(@condition.start_values.size).to be(10)
  end

  it "should NOT have start_values if chain-specific values are defined" do
    expect(@last_condition.start_values["each_chain"]).to be_a(String)
  end

  it "should have target_values if condition-wide values are defined" do
    expect(@condition.target_values.size).to be(10)
  end

  it "should NOT have target_values if chain-specific values are defined" do
    expect(@last_condition.target_values["each_chain"]).to be_a(String)
  end

  describe "#fitness" do 
    it "should return integer when called on conditions with condition-specific target values" do 
      expect(@condition.fitness(sample_positive)).to be_a(Integer)
    end
    it "should throw an error when called on conditions with chain-specific target values" do
      expect{@experiment.conditions[-1].fitness(sample_positive)}.to raise_error(RuntimeError)
    end
  end

end