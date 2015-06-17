class Generation < ActiveRecord::Base

  belongs_to :chain, inverse_of: :generations  
  validates_presence_of :chain, :position

  has_many :tasks, dependent: :destroy, inverse_of: :generation
  before_create :build_tasks

  serialize :start_values, JSON

  # setup the generation's start values 
  # and prepare tasks
  def prepare(start_vals)
    train_ratio = chain.condition.experiment.percent_test_for_training / 100.0
    self.start_values = IterativeLearning.training_test_split(start_vals, train_ratio)
    self.save!
    tasks.each(&:prepare)
  end

  # propagate task completion event
  # up the experiment hierarchy
  def update_experiment(task)
    if next_gen.present? and self.complete? # prepare next generation?
      # send this generation's best task response to next generation
      best = best_task_response
      if best.is_a? Hash
        next_start_vals = best['testing']
      else
        next_start_vals = best
      end
      next_gen.prepare(next_start_vals)
    end
    chain.update_experiment(task)
  end


  # Previous generation in the chain
  #
  def prev_gen
    if self.position > 0
      chain.generations[self.position-1]
    else
      nil
    end
  end


  # Next generation in the chain
  #
  def next_gen
    if self.position < chain.generations.length-1
      chain.generations[self.position+1]
    else
      nil
    end
  end


  # Is this the active generation?
  #
  def active?
    !complete? and (prev_gen.nil? or prev_gen.complete?)
  end


  # All the tasks complete?
  #
  def complete?
    tasks.all?(&:complete?)
  end


  # Returns the task reponse that is 
  # the 'best' among the child tasks
  #
  def best_task_response
    if complete?
      best_score = Float::INFINITY
      best_task = nil
      tasks.each do |t|
        score = t.response_fitness
        if score < best_score
          best_task = t 
          best_score = score
        end
      end
      best_task.response_values
    end
  end


  protected


  def build_tasks
    num_tasks = chain.condition.experiment.tasks_per_generation
    num_tasks.times{ tasks.build } if tasks.empty?
  end

end