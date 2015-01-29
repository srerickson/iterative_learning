require 'jwt'
require 'yaml'

class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment
  serialize :frontend_config, JSON



  def prepare
    conditions.each(&:prepare)
  end

  def update_experiment(task)
    # the experiment was update with the completion of {task}
  end

  def jwt_key
    JWT.encode({
      experiment_name: self.name
    }, ENV['IL_SECRET'])
  end


  def self.build_from_config(conf_file)
    experiment_configs = YAML.load_file(conf_file)
    experiment_configs.each_pair do |name, configs| 
      experiment = Experiment.find_or_initialize_by({name: name})

      # rebuild 
      # FIXME - shouldn't be default behavior
      experiment.conditions.destroy_all
      
      experiment.frontend_config = configs['frontend_config']

      # build conditions associations
      configs.delete('conditions').each do |cond_config|
        condition = experiment.conditions.build(cond_config)
      end
      experiment.update_attributes!( configs )
      experiment.prepare
    end
  end


end