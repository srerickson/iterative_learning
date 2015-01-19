require "spec_helper"


describe IterativeLearning::API do

  include Rack::Test::Methods

  def app
    IterativeLearning::API
  end


  before :each do
    @task = @experiment.conditions.first.chains.first.generations.first.tasks.first
    @valid_data = {
      task: {
        response_values: {
          testing: IterativeLearning::FunctionLearning.positive(10),
          training: IterativeLearning::FunctionLearning.positive(10)
        }
      }
    }
    @invalid_data = {
      task: {
        response_values: {
          testing: IterativeLearning::FunctionLearning.positive(9),
          training: IterativeLearning::FunctionLearning.positive(9)
        }
      }
    }
  end


  describe "POST /task?key" do

    it "it works with valid data" do
      key = @task.jwt_key
      post "/task?key=#{key}", JSON.generate(@valid_data), { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq(201)
    end


    it "it returns error if invalid key" do
      key = "wrong"
      post "/task?key=#{key}", JSON.generate(@valid_data), { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq(500)
    end


    it "it returns error if invalid task data doesn't have right length" do
      key = @task.jwt_key
      post "/task?key=#{key}", JSON.generate(@invalid_data), { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq(500)
      expect(@task.response_values).to eq(nil)
    end


  end

end