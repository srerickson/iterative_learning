class Chain < ActiveRecord::Base

  belongs_to :condition, inverse_of: :chains
  
  has_many :generations, dependent: :destroy, inverse_of: :chain

  validates_presence_of :condition

end