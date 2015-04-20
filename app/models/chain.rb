class Chain < ActiveRecord::Base

  belongs_to :condition, inverse_of: :chains
  validates_presence_of :condition

  has_many :generations, -> { order('position ASC')}, dependent: :destroy, inverse_of: :chain
  before_create :build_generations

  def prepare 
    # prepare the first genertion
    # QUESTION: partition here or later?
    first_generation.prepare(condition.start_values)
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

  protected 

  def build_generations
    num_generations = condition.experiment.generations_per_chain
    num_generations.times{|i| generations.build(position: i) } if generations.empty?
  end


end