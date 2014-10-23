class Condition < ActiveRecord::Base

  belongs_to :experiment, inverse_of: :conditions
  validates_presence_of :experiment

  has_many :chains, dependent: :destroy, inverse_of: :condition
  before_create :build_chains

  protected

  def build_chains 
    if chains.empty? and experiment.chains_per_condition > 0
      experiment.chains_per_condition.times{ chains.build }
    end
  end

end