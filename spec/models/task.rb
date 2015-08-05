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

    describe "#clear!" do
      it "deletes response values and demographics" do
        @task.response_values = sample_positive(10)
        @task.demographics = {gender: "Male"}
        @task.save!

        expect(@task.complete?).to be(true)
        @task.clear!
        expect(@task.complete?).to be(false)
      end
    end

    describe "#reset!" do
      it "makes the task's current generation active" do
        expect(@task.generation.active?).to be(true)
        # complete all the tasks in the generation
        @task.generation.tasks.each do |t|
          t.response_values = sample_positive(10)
          t.save!
          t.update_experiment
        end
        # task's generation should now be complete
        expect(@task.reload.generation.active?).to be(false)
        expect(@task.generation.next_gen.active?).to be(true)
        @task.reset!
        expect(@task.reload.generation.active?).to be(true)
        expect(@task.generation.next_gen.active?).to be(false)
      end
    end


  end


  describe "in the Mturk context" do


    before :each do
      @experiment = rebuild_experiment("spec_mturk")
      @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
    end

    describe "mturk_disableHit" do
      it "should set mturk_hit_id to nil" do
        expect(@task.mturk_hit_id).to_not be nil
        @task.mturk_disableHit
        expect(@task.reload.mturk_hit_id).to be nil
      end
    end

    it "should disableHIT during clear" do
      expect(@task.requester).to receive(:disableHIT)
      @task.clear
    end

    it "should createHIT during prepare" do
      expect(@task.requester).to receive(:createHIT).and_call_original
      @task.prepare
    end

    it "should disableHIT before destroy" do
      hit = @task.mturk_getHit
      expect(hit).to_not be(nil)
      expect(@task.requester).to receive(:disableHIT)
      @task.destroy
    end


  end


end