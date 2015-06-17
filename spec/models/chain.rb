require "spec_helper"

describe "Chain" do
  
  before :each do
    @experiment = rebuild_experiment("spec_experiment1")
    @chain = @experiment.conditions.first.chains.first
    @random_chain = @experiment.conditions[-1].chains.first
  end

  it "should be valid with correct values" do
    expect(@chain).to be_valid
  end

  it "should call conditions's update_experiment when update_experiment is called" do
    expect(@chain.condition).to receive(:update_experiment).with(123)
    @chain.update_experiment(123)
  end

  it "should call prepare on first generation when prepare is called" do
    expect(@chain.first_generation).to receive(:prepare).with(@chain.condition.start_values)
    @chain.prepare

    expect(@random_chain.first_generation).to receive(:prepare).with(@random_chain.start_values)
    @random_chain.prepare
  end

  it "should have start_values if chain-specific values are defined" do
    expect(@random_chain.start_values.size).to be(10)
  end

  it "should NOT have empty start_values if condition-wide values are defined" do
    expect(@chain.start_values.size).to be(0)
  end

  it "should have target_values if chain-specific values are defined" do
    expect(@random_chain.target_values.size).to be(10)
  end

  it "should NOT have target_values if condition-wide values are defined" do
    expect(@chain.target_values.size).to be(0)
  end

  describe "#fitness" do 
    it "should call fitness on parent condition if target_values are not defined" do 
      expect(@chain.condition).to receive(:fitness).with(sample_positive)
      @chain.fitness(sample_positive)
    end

    it "should NOT call fitness on parent condition if target_values are defined" do 
      expect(@random_chain.condition).not_to receive(:fitness)
      @random_chain.fitness(sample_positive)
    end

    it "should return integer if target values are defined" do
      expect(@experiment.conditions[-1].chains.first.fitness(sample_positive)).to be_a(Integer)
    end
  end

end