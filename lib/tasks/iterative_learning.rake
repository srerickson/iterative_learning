require 'yaml'

namespace :il do 

  task :build => :environment do 
    experiment_configs = YAML.load_file ENV['EXP_FILE'] || 'config/experiments.yml'
    experiment_configs.each_pair do |name, configs| 
      experiment = Experiment.find_or_initialize_by({name: name})

      # rebuild 
      experiment.conditions.destroy_all
      
      # build conditions associations
      configs.delete('conditions').each do |cond_config|
        condition = experiment.conditions.build
        condition.start_values = IterativeLearning.build_condition(cond_config['start_values'], 100)
        condition.target_values = IterativeLearning.build_condition(cond_config['target_values'], 100)
      end
      experiment.update_attributes!( configs )
    end

  end

  task :list => :environment do 
    Experiment.all.each do |e|
      puts "#{e.name}\t| #{e.jwt_key}"
    end
  end

end
