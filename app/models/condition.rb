class Condition < ActiveRecord::Base

  serialize :start_values, JSON
  serialize :target_values, JSON

  belongs_to :experiment, inverse_of: :conditions
  validates_presence_of :experiment

  has_many :chains, dependent: :destroy, inverse_of: :condition
  before_create :build_chains

  def prepare 
    chains.each(&:prepare)
  end

  def update_experiment(task)
    experiment.update_experiment(task)
  end

  protected 

  def build_chains
    num_chains = experiment.chains_per_condition
    num_chains.times{ chains.build } if chains.empty?
  end

end