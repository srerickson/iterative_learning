require 'jwt'
require 'entities'

module IterativeLearning

  class API < Grape::API

    format :json

    resource :experiment do 
      params do
        requires :key, type: String, desc: "JWT experiment key"
      end
      get do 
        jwt = JWT.decode(params[:key], ENV["IL_SECRET"])
        exp_id = jwt[0]['experiment_id']
        present Experiment.find(exp_id), with: IterativeLearning::Entities::Experiment
      end
    end


    resource :tasks do 
      params do
        requires :key, type: String, desc: "JWT task key"
      end
      get do
        jwt = JWT.decode(params[:key], ENV["IL_SECRET"])
        task_id = jwt[0]['task_id']
        present Task.find(task_id), with: IterativeLearning::Entities::Task
      end
    end

  end

end