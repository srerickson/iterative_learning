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

  def fitness(vals)
    # FIXME -- use the registered fitness function
    IterativeLearning::FunctionLearning.sum_of_error(self.target_values, vals)
  end

  def start_values=vals
    vals = IterativeLearning.build_condition(vals) if vals.is_a? String
    super(vals)
  end

  def target_values=vals
    vals = IterativeLearning.build_condition(vals) if vals.is_a? String
    super(vals)
  end

  protected 

  def build_chains
    num_chains = experiment.chains_per_condition
    num_chains.times{ chains.build } if chains.empty?
  end

end