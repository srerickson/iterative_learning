class Generation < ActiveRecord::Base

  belongs_to :chain, inverse_of: :generations  
  validates_presence_of :chain, :position

  has_many :tasks, dependent: :destroy, inverse_of: :generation
  before_create :build_tasks

  serialize :start_values, JSON

  def prepare
    if start_values.empty? 
      if position == 0
        self.start_values = IterativeLearning.partition_values chain.condition.start_values
      else
        self.start_values = IterativeLearning.repartition_values prev_gen.best_task_response
      end
      self.save!
    end
    tasks.each(&:prepare)
  end

  def update_experiment(task)
    next_gen.prepare if self.complete?
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
  def best_task_response
    if complete? 
      tasks.first.response_values # FOR TESTING
    else
      nil
    end
  end


  protected


  def build_tasks
    num_tasks = chain.condition.experiment.tasks_per_generation
    num_tasks.times{ tasks.build } if tasks.empty?
  end

end