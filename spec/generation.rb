require "spec_helper"

describe "Generation" do
  before :each do
    @experiment = Experiment.new({
      chains_per_condition: 1,
      generations_per_chain: 3,
      tasks_per_generation: 4
    })
    @experiment.conditions.build(start_values: [1,2,3])
    @experiment.save   
    @experiment.prepare


    @gen_1 = @experiment.conditions.first.chains.first.generations[0]
    @gen_2 = @experiment.conditions.first.chains.first.generations[1]
    @gen_3 = @experiment.conditions.first.chains.first.generations[2]

  end

  it "should be valid with correct values" do
    expect(@gen_1).to be_valid
  end


  it "should have a start value if first generation" do
    expect(@gen_1.start_values).not_to be_empty
  end


  describe '#prev_gen' do 
    it "should return nil if first generation in chain" do
      expect(@gen_1.prev_gen).to be_nil
    end
    it "should return previous generation" do
      expect(@gen_2.prev_gen).to eq(@gen_1)
    end
  end


  it "should prepare next generation after completion" do

    expect(@gen_1.active?).to eq(true)
    expect(@gen_2.active?).to eq(false)
    expect(@gen_2.start_values).to be_empty

    @gen_1.tasks.each do |t|
      t.update_attributes(response_values: {training: [1,2,3], testing: [4,5,6]})
      t.update_experiment
    end
    
    expect(@gen_1.active?).to eq(false)
    expect(@gen_2.active?).to eq(true)
    expect(@gen_2.start_values).not_to be_empty

  end


  after :each do 
    @experiment.destroy
  end


end