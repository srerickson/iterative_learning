class Task < ActiveRecord::Base

  belongs_to :generation, inverse_of: :tasks
  validates_presence_of :generation

  serialize :start_values, JSON
  serialize :response_values, JSON

  # after_commit :update_experiment

  def prepare
    # build HIT if mturk
    self.start_values = generation.start_values
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


end