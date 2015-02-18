require 'jwt'
require 'yaml'

class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment
  serialize :frontend_config, JSON
  validates_uniqueness_of :name

  def prepare
    conditions.each(&:prepare)
  end

  def update_experiment(task)
    # the experiment was update with the completion of {task}
  end

  def jwt_key
    JWT.encode({
      experiment_name: self.name
    }, ENV['IL_SECRET'])
  end

end