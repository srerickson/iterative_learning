require 'jwt'

class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment

  def prepare
    conditions.each(&:prepare)
  end

  def update_experiment(task)
    # the experiment was update with the completion of {task}
  end

  def jwt_key
    JWT.encode({experiment_id: self.id}, ENV['IL_SECRET'])
  end

end