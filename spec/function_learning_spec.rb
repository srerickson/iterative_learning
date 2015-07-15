require "spec_helper"

describe IterativeLearning::FunctionLearning do


  describe "#positive" do 
    it "returns a positive function" do
      fun = IterativeLearning::FunctionLearning.positive(5,[1,10])
      pos = [{x:1, y:1}, {x:3, y:3}, {x:6, y:6}, {x:8, y:8}, {x:10, y:10}]
      expect(fun).to eq(pos)
    end
  end


  describe "#negative" do 
    it "returns a negative function" do
      fun = IterativeLearning::FunctionLearning.negative(5,[1,10])
      neg = [{x:1, y:10}, {x:3, y:8}, {x:6, y:5}, {x:8, y:3}, {x:10, y:1}]
      expect(fun).to eq(neg)
    end
  end


  describe "#v_shape" do 
    it "returns a v-shape function" do
      fun = IterativeLearning::FunctionLearning.v_shape(5,[1,10])
      vsh = [{x:1, y:9}, {x:3, y:5}, {x:6, y:1}, {x:8, y:5}, {x:10, y:9}]
      expect(fun).to eq(vsh)
    end
  end


  describe "#v_shape" do 
    it "returns a v-shape function" do
      fun = IterativeLearning::FunctionLearning.v_shape(5,[1,10])
      vsh = [{x:1, y:9}, {x:3, y:5}, {x:6, y:1}, {x:8, y:5}, {x:10, y:9}]
      expect(fun).to eq(vsh)
    end
  end


  describe "#random" do
    it "returns identical functions for identical seeds" do
      rand1 = IterativeLearning::FunctionLearning.random(5,[1,10], 1234)
      rand2 = IterativeLearning::FunctionLearning.random(5,[1,10], 1234)
      expect(rand1).to eq(rand2)
    end

    it "works without a provided seed" do 
      rand = IterativeLearning::FunctionLearning.random(5,[1,10])
      expect(rand.size).to eq(5)
    end
  end


  describe "#sum_of_error" do

    it "returns the sum of error for two arrays of x/y values" do 
      test1 = [{x:1,y:1},{x:6,y:6},{x:3,y:3},{x:8,y:8},{x:10,y:10}]
      test2 = [{x:1,y:3},{x:3,y:3},{x:6,y:6},{x:8,y:8},{x:10,y:10}]
      expect(IterativeLearning::FunctionLearning.sum_of_error(test1,test2)).to eq(2)
    end

    it "uses an array under 'testing' if the input is a Hash" do 
      test1 = {'testing'=>[{x:1,y:1},{x:6,y:6},{x:3,y:3},{x:8,y:8},{x:10,y:10}]}
      test2 = [{x:1,y:3},{x:3,y:3},{x:6,y:6},{x:8,y:8},{x:10,y:10}]
      expect(IterativeLearning::FunctionLearning.sum_of_error(test1,test2)).to eq(2)
    end

    it "throws an error if the arrays are not of equal length" do
      test1 = {'testing'=>[{x:1,y:1},{x:3,y:3},{x:6,y:6},{x:8,y:8},{x:10,y:10}]}
      test2 = {'testing'=>[{x:1,y:3},{x:3,y:3},{x:6,y:6},{x:8,y:8}]}
      expect{IterativeLearning::FunctionLearning.sum_of_error(test1,test2)}.to raise_error(RuntimeError)
    end

    it "throws an error if the arrays' x-values don't correspond" do
      test1 = {'testing'=>[{x:1,y:1},{x:4,y:3},{x:6,y:6},{x:8,y:8},{x:10,y:10}]}
      test2 = {'testing'=>[{x:1,y:1},{x:3,y:3},{x:6,y:6},{x:8,y:8},{x:10,y:10}]}
      expect{IterativeLearning::FunctionLearning.sum_of_error(test1,test2)}.to raise_error(RuntimeError)
    end

  end



end