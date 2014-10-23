class Generation < ActiveRecord::Base

  belongs_to :chain, inverse_of: :generations  
  validates_presence_of :chain

  has_many :tasks, dependent: :destroy, inverse_of: :generation
  before_create :build_tasks

  def experiment
    self.chain.condition.experiment
  end

  def prev
    i = chain.generations.find_index(self)
    if i > 0 
      chain.generations[i-1]
    else
      nil
    end
  end

  def active?
    prev.nil? || prev.complete?
  end

  def complete?
    tasks.all? {|t| t.complete? }
  end

  protected

  def build_tasks
    if tasks.empty? and experiment.tasks_per_generation > 0
      experiment.tasks_per_generation.times{ tasks.build }
    end
  end

end