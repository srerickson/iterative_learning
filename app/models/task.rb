class Task < ActiveRecord::Base

  belongs_to :generation, inverse_of: :tasks
  
  validates_presence_of :generation
  #validates_associated :generation

  def doable?
    generation.active?
  end

  def complete?
    !self.response.nil?
  end

  def jwt_key
    JWT.encode({task_id: self.id}, ENV['IL_SECRET'])
  end

end