require 'jwt'

class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment


  def jwt_key
    JWT.encode({experiment_id: self.id}, ENV['IL_SECRET'])
  end

end