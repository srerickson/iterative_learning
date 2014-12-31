

class Task < ActiveRecord::Base

  belongs_to :generation, inverse_of: :tasks
  validates_presence_of :generation

  serialize :start_values, JSON
  serialize :response_values, JSON

  before_destroy :disable_hit

  def prepare
    self.start_values = generation.start_values
    # build HIT if mturk
    if experiment.is_mturk
      result = IterativeLearning::MTurk::createHIT(
        self.url,
        experiment.mturk_title,
        experiment.mturk_description,
        experiment.mturk_keywords,
        experiment.mturk_award
      )
      self.mturk_hit_id = result[:HITId]
    end    
    self.save!
  end

  def update_experiment
    generation.update_experiment(self)
  end

  def complete?
    !self.response_values.nil?
  end

  def jwt_key
    JWT.encode({task_id: self.id}, ENV['IL_SECRET'])
  end

  def url
    ENV["BASE_URL"] + "/#/task/key=#{jwt_key}"
  end

  def response_fitness
    self.generation.chain.condition.fitness( self.response_values )
  end

  def experiment
    generation.chain.condition.experiment
  end

  def frontend_config
    experiment.frontend_config
  end

  def mturk_url
    ""
  end

  def mturk_hit
    IterativeLearning::MTurk::requester.getHIT({HITId: mturk_hit_id})
  end


  def disable_hit
    if mturk_hit_id
      IterativeLearning::MTurk::requester.disableHIT({HITId: mturk_hit_id})
    end
  end



end