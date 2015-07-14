class Chain < ActiveRecord::Base

  serialize :start_values, JSON
  serialize :target_values, JSON

  belongs_to :condition, inverse_of: :chains
  validates_presence_of :condition

  has_many :generations, -> { order('position ASC')}, dependent: :destroy, inverse_of: :chain
  before_create :build_generations


  # Prepare the chain for the experiment run.
  # Values may be shared by all chains in the condition
  # or be chain-specific.
  def prepare 
    # initialize start values, prepare first generation
    begin
      self.start_values = IterativeLearning.build_condition(condition.start_values["each_chain"], self)
      first_generation.prepare(self.start_values)
    rescue StandardError => e
      first_generation.prepare(condition.start_values)
      self.start_values = []
    end
    # initialize target values, if present
    begin
      self.target_values = IterativeLearning.build_condition(condition.target_values["each_chain"], self)
    rescue StandardError
      self.target_values = []
    end
    self.save!
  end

  # Calculates the difference betwenn vals and some target
  # - first tries chain-specific target values
  # - if that fails, reverts to condition's target values
  def fitness(vals)
    begin
      IterativeLearning::FunctionLearning.sum_of_error(self.target_values, vals)
    rescue StandardError
      condition.fitness(vals)
    end
  end

  def first_generation
    @first_generation ||= generations.first
  end

  def update_experiment(task)
    condition.update_experiment(task)
  end

  # Make sure the start_values for each generation are correct
  def integrity_check
    start_values = condition.start_values
    generations.each do |g|
       # FIXME -- use the registered fitness function
      if IterativeLearning::FunctionLearning.sum_of_error(g.start_values, start_values) != 0
        return false
      end
      start_values = g.best_task_response
    end
    return true
  end

  def position
    condition.chains.index(self)
  end

  protected 

  def build_generations
    num_generations = condition.experiment.generations_per_chain
    num_generations.times{|i| generations.build(position: i) } if generations.empty?
  end


end