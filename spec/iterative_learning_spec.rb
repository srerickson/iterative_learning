require "spec_helper"

describe IterativeLearning do

  describe "#build_condition" do
    it "does FUNC_FROMTASK" do
      # build a task with valid response values
      experiment = rebuild_experiment("spec_experiment1")
      vals = IterativeLearning::FunctionLearning.positive(5,[1,10]).map(&:with_indifferent_access)
      task = experiment.conditions[0].chains[0].generations[0].tasks[0]
      task.response_values = { "testing" => vals }
      task.save!

      # test
      expect(IterativeLearning.build_condition("FUNC_FROMTASK(#{task.id})")).to eq(vals)
    end

    it "does FUNC_POSITIVE" do 
      vals = IterativeLearning::FunctionLearning.positive(5,[1,10])
      expect(IterativeLearning.build_condition("FUNC_POSITIVE(5,[1,10])")).to eq(vals) 
    end 

    it "does FUNC_NEGATIVE" do 
      vals = IterativeLearning::FunctionLearning.negative(5,[1,10])
      expect(IterativeLearning.build_condition("FUNC_NEGATIVE(5,[1,10])")).to eq(vals) 
    end 

  end
end