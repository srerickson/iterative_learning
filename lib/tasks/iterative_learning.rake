require 'yaml'

namespace :il do 


  def create_experiment(config)
    experiment = Experiment.new()
    config.delete('conditions').each do |cond_config|
      condition = experiment.conditions.build(cond_config)
    end
    experiment.update_attributes!( config )
    experiment.prepare
  end


  task :build, [:only_experiment, :config_file] => :environment do |t, args|
    args.with_defaults(config_file: 'config/experiments.yml')
    experiment_configs = YAML.load_file(args[:config_file])
    experiment_configs.each_pair do |name, configs| 
      next if args[:only_experiment].present? and name != args[:only_experiment]
      if Experiment.where({name: name}).size > 0
        puts "skipping: #{name} (already built)"
      else
        puts "building: #{name} ..."
        configs['name'] = name
        create_experiment(configs)
      end
    end
    puts "done"
  end


  task :rebuild, [:only_experiment, :config_file] => :environment do |t, args|
    args.with_defaults(config_file: 'config/experiments.yml')
    experiment_configs = YAML.load_file(args[:config_file])
    experiment_configs.each_pair do |name, configs|
      next if args[:only_experiment].present? and name != args[:only_experiment]
      if old_experiment = Experiment.where(name: name).first
        puts "removing: #{old_experiment.name}"
        old_experiment.destroy
      end
      puts "building #{name}"
      configs['name'] = name
      create_experiment(configs)
    end
    puts "done"
  end


  task :remove, [:only_experiment] => :environment do |t,args|
    if experiment = Experiment.where(name: args[:only_experiment]).first
      puts "removing: #{experiment.name}"
      experiment.destroy
    end
    puts "done"
  end


  task :list => :environment do 
    Experiment.all.each do |e|
      puts "#{e.name}\t| #{e.jwt_key}"
    end
  end

  
  task :clear_hits => :environment do 
    r = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
    hits = r.searchHITs({PageSize: 100})[:HIT]
    if hits
      hits.each{|h| r.disableHIT({HITId: h[:HITId]})}
    end
  end


end
