require "spec_helper"

describe "Task" do

  describe "in the general context" do

    before :each do
      @experiment = rebuild_experiment("spec_experiment1")
      @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
    end

    it "should be valid with correct values" do
      expect(@task).to be_valid
    end

    it "should call generation's update_experiment when update_experiment is called" do
      expect(@task.generation).to receive(:update_experiment).with(@task)
      @task.update_experiment
    end


    describe "#response_fitness" do
      it "returns an integer" do
        @task.response_values = sample_positive
        expect(@task.response_fitness).to be_an(Integer)
      end

      it "calls fitness on parent chain" do
        @task.response_values = sample_positive
        parent_chain = @task.generation.chain
        expect(parent_chain).to receive(:fitness).with(@task.response_values)
        @task.response_fitness
      end

    end

    describe "#reset" do 
      it "deletes response values and demographics" do
        @task.response_values = sample_positive(10)
        @task.demographics = {gender: "Male"}
        @task.reset
        expect(@task.response_values).to be(nil)
        expect(@task.demographics).to be_empty
      end

      it "calls reset on next generation (by default)" do
        gen2 = @task.generation.next_gen
        @task.response_values = sample_positive(10)
        @task.update_experiment
        expect(gen2).to receive(:reset)
        @task.reset
      end

    end

  end


  describe "in the Mturk context" do


    before :each do
      @experiment = rebuild_experiment("spec_mturk")
      @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
    end

    it "should createHit during prepare" do
      expect(@task.requester).to receive(:createHIT).and_call_original
      @task.prepare
    end

    it "should disable the HIT before destroy" do 
      hit = @task.mturk_getHit
      expect(hit).to_not be(nil)
      expect(@task.requester).to receive(:disableHIT)
      @task.destroy
    end


  end


end