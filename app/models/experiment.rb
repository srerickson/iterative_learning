require 'jwt'
require 'yaml'

class Experiment < ActiveRecord::Base

  has_many :conditions, dependent: :destroy, inverse_of: :experiment

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
      experiment.conditions.destroy_all
      
      # build conditions associations
      configs.delete('conditions').each do |cond_config|
        condition = experiment.conditions.build
        num_values = cond_config['num_values']
        value_range = cond_config['range']
        if value_range
          condition.start_values = IterativeLearning.build_condition(cond_config['start_values'], num_values, value_range)
          condition.target_values = IterativeLearning.build_condition(cond_config['target_values'], num_values, value_range)
        else 
          condition.start_values = IterativeLearning.build_condition(cond_config['start_values'], num_values)
          condition.target_values = IterativeLearning.build_condition(cond_config['target_values'], num_values)
        end
        condition.name = cond_config['name']
      end
      experiment.update_attributes!( configs )
      experiment.prepare
    end
  end


end