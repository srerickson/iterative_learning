class Chain < ActiveRecord::Base

  belongs_to :condition, inverse_of: :chains
  validates_presence_of :condition

  has_many :generations, dependent: :destroy, inverse_of: :chain
  before_create :build_generations

  def experiment
    self.condition.experiment
  end

  protected 
  
  def build_generations
    if generations.empty? and experiment.generations_per_chain > 0
      experiment.generations_per_chain.times{ generations.build }
    end
  end

end