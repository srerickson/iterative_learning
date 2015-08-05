require 'jwt'
require 'entities'

module IterativeLearning

  class API < Grape::API

    format :json
    logger Logger.new(File.expand_path("../../../access.log", __FILE__))

    rescue_from :all do |e|
      API.logger.error "#{e.message}\n#{e.backtrace.join("\n")}"
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end

    after do
      API.logger.info({
        short_message: "[#{status}] #{request.request_method} #{request.path}",
        code: status,
        ip: request.ip,
        user_agent: request.user_agent,
        params: request.params.except('route_info').to_hash,
      })
    end


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

        # check if mturk worker has already submitted
        if params[:workerId].present? and Task.where(mturk_worker_id: params[:workerId] ).count > 0
          error! 'Unauthorized', 401, 'X-Error-Detail' => 'blah blah'
        else
          present Task.find(task_id), with: IterativeLearning::Entities::Task
        end
      end

      params do
        requires :key, type: String, desc: "JWT task key"
        requires :task
      end
      post do
        jwt = JWT.decode(params[:key], ENV["IL_SECRET"])
        task_id = jwt[0]['task_id']
        task = Task.find(task_id)
        # error if the task is already complete
        # (we don't want to overwrite the data)
        if task.complete?
          error!('task is already complete', 500)
        else
          begin # High Priority (send email on error)
            # sanity check the response values
            # - response values should have measurable fitness
            # - this will throw an error if response_values doesn't look right
            # - request will abort (rescue_all)
            task.generation.chain.fitness( params[:task][:response_values] )
            # save responses, update the experiment
            task.update_attributes!(params[:task])
            task.update_experiment
            task.mturk_disableHit # noop if not mturk experiment
          rescue StandardError => e
            msg = "task_id: #{task_id}\n"
            msg += "#{e.message}\n#{e.backtrace.join("\n")}"
            IterativeLearning.send_error_email msg
            throw e
          end
          begin # Low Priority
            task.send_notification_email # noop if notification address not set
          rescue StandardError => e
            API.logger.error "#{e.message}\n#{e.backtrace.join("\n")}"
          end
        end # task.complete?
      end #post


    end

  end

end