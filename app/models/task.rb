require 'il/mturk'

class Task < ActiveRecord::Base

  belongs_to :generation, inverse_of: :tasks
  validates_presence_of :generation

  serialize :start_values, JSON
  serialize :response_values, JSON
  serialize :demographics, JSON

  include IterativeLearning::MTurk
  before_destroy :mturk_disableHit

  # - setup start values
  # - overwrite any response data!
  # - setup mturk if necessary
  def prepare
    self.start_values = generation.start_values
    self.response_values = nil
    self.demographics = {}
    # build HIT if mturk
    if experiment.is_mturk
      begin
        result = createHIT(
          self.url,
          experiment.mturk_title,
          experiment.mturk_description,
          experiment.mturk_keywords,
          experiment.mturk_award, 
          experiment.mturk_duration,
          experiment.mturk_lifetime,
          experiment.mturk_sandbox
        )
        if result
          self.mturk_hit_id = result[:HITId]
        else
          throw "failed to createHIT for task: #{id}"
        end
      rescue Amazon::WebServices::Util::ValidationException => e
        throw e unless e.message == "AWS.MechanicalTurk.HITAlreadyExists"
      end
    end # if experiment.is_mturk
    save!
  end

  # send update event up the experiment hierarchy
  def update_experiment
    generation.update_experiment(self)
  end

  # clear any task results, prepare 
  # resets all future generations
  def reset(propagate=true)
    self.prepare
    if (n = generation.next_gen) and propagate
      n.reset
    end
  end

  def complete?
    !self.response_values.nil?
  end

  def jwt_key
    JWT.encode({task_id: self.id}, ENV['IL_SECRET'])
  end

  def url
    ENV["BASE_URL"] + "/#/task?key=#{jwt_key}"
  end

  def response_fitness
    self.generation.chain.fitness( self.response_values )
  end

  def experiment
    generation.chain.condition.experiment
  end

  def position
    generation.tasks.index(self)
  end

  def config
    experiment.config
  end

  def send_notification_email
    IterativeLearning.send_task_notification(self)
  end

  def mturk_getHit
    requester(experiment.mturk_sandbox).getHIT({HITId: mturk_hit_id})
  end

  def mturk_disableHit
    if mturk_hit_id
      requester(experiment.mturk_sandbox).disableHIT({HITId: mturk_hit_id})
    end
  rescue Amazon::WebServices::Util::ValidationException => e
    throw e unless e.message == "AWS.MechanicalTurk.HITDoesNotExist"
  end


end
