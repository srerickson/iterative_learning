class Generation < ActiveRecord::Base

  belongs_to :chain, inverse_of: :generations  
  has_many :tasks, dependent: :destroy, inverse_of: :generation

  validates_presence_of :chain

  def prev
    i = chain.generations.find_index(self)
    if idx > 0 
      chain.generations[i-1]
    else
      null
    end
  end


  def complete?
    tasks.all? {|t| t.complete? }
  end

end