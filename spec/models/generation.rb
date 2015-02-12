require "spec_helper"

describe "Generation" do
  before :each do
    rebuild_experiment
    @experiment = Experiment.first
    @gen_1 = @experiment.conditions.first.chains.first.generations[0]
    @gen_2 = @experiment.conditions.first.chains.first.generations[1]
    @gen_3 = @experiment.conditions.first.chains.first.generations[2]
  end
  
  it "should be valid with correct values" do
    expect(@gen_1).to be_valid
  end


  it "should have test/traing start value if first generation" do
    expect(@gen_1.start_values).not_to be_empty
    expect(@gen_1.start_values.keys).to include('training','testing')
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
      t.update_attributes(response_values: sample_positive )
      t.update_experiment
    end
    
    expect(@gen_1.reload.active?).to eq(false)
    expect(@gen_2.reload.active?).to eq(true)
    expect(@gen_2.start_values).not_to be_empty

  end

  it "calculates best task response" do
    @gen_1.tasks.each_with_index do |t,i|
      t.update_attribute(:response_values, sample_positive.map{|val| {x:val[:x],y:val[:y]+i } }) 
    end
    expect(@gen_1.best_task_response[0]).to eq({"x"=>1, "y"=>1})
  end

  it "uses experiment's percent_test_for_training" do
    @experiment.update_attributes(percent_test_for_training: 40)
    @experiment.prepare
    training_size = @gen_1.reload.start_values["training"].length.to_f
    testing_size = @gen_1.reload.start_values["testing"].length.to_f
    expect(training_size / testing_size).to eq(0.4)
  end


  it "should call chains's update_experiment when update_experiment is called" do
    expect(@gen_1.chain).to receive(:update_experiment).with(123)
    @gen_1.update_experiment(123)
  end


  it "should call prepare on all tasks when prepare is called" do
    @gen_1.tasks.each{ |t| expect(t).to receive(:prepare) }
    @gen_1.prepare(sample_positive)
  end
end