class Condition < ActiveRecord::Base

  belongs_to :experiment, inverse_of: :conditions
  
  has_many :chains, dependent: :destroy, inverse_of: :condition

  validates_presence_of :experiment

end