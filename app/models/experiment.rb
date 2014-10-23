class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment


end