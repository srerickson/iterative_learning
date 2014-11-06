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
        exp_name = jwt[0]['experiment_name']
        present Experiment.find_by_name(exp_name), with: IterativeLearning::Entities::Experiment
      end
    end


    resource :task do 
      params do
        requires :key, type: String, desc: "JWT task key"
      end
      get do
        jwt = JWT.decode(params[:key], ENV["IL_SECRET"])
        task_id = jwt[0]['task_id']
        present Task.find(task_id), with: IterativeLearning::Entities::Task
      end

      params do
        requires :key, type: String, desc: "JWT task key"
        requires :task
      end
      post do
        puts params
        jwt = JWT.decode(params[:key], ENV["IL_SECRET"])
        task_id = jwt[0]['task_id']
        task = Task.find(task_id)
        task.update_attributes!(params[:task])
        task.update_experiment
      end


    end

  end

end