class Chain < ActiveRecord::Base

  belongs_to :condition, inverse_of: :chains
  validates_presence_of :condition

  has_many :generations, -> { order('position ASC')}, dependent: :destroy, inverse_of: :chain
  before_create :build_generations

  def prepare 
    # prepare the first genertion
    generations.first.prepare
  end


  def update_experiment(task)
    condition.update_experiment(task)
  end

  protected 

  def build_generations
    num_generations = condition.experiment.generations_per_chain
    num_generations.times{|i| generations.build(position: i) } if generations.empty?
  end


end