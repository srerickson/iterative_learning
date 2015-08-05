require 'yaml'
require 'pp'

namespace :il do 

  def create_experiment(config)
    experiment = Experiment.new()
    config.delete('conditions').each do |cond_config|
      condition = experiment.conditions.build(cond_config)
    end
    experiment.update_attributes!( config )
    experiment.prepare
  end


  task :build, [:config_file] => :environment do |t, args|
    begin
      # Argument can be:
      # - path to YML file
      # - basename of YML file in experiments folder
      if args[:config_file] =~ /^.*\.yml$/
        config = YAML.load_file(args[:config_file])
      else
        config = YAML.load_file("experiments/#{args[:config_file]}.yml")
      end
      config['name'] = File.basename(args[:config_file], '.yml')
      if Experiment.where({name: config['name']}).size > 0
        puts "skipping: #{config['name']} (already built)"
      else
        puts "building: #{config['name']} ..."
        create_experiment(config)
        puts "done"
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end


  task :remove, [:name] => :environment do |t,args|
    begin 
      if experiment = Experiment.where(name: args[:name]).first
        puts "removing: #{experiment.name}"
        experiment.destroy
        puts "done"
      else
        puts "no experiment with that name"
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end


  task :list => :environment do 
    experiments = Experiment.all
    puts "Found #{experiments.count} experiment(s)"
    experiments.each do |e|
      puts "------------------------------------------"
      puts "name: #{e.name}"
      puts "description: #{e.description}"
      puts "access key: #{e.jwt_key}"
    end
    puts "------------------------------------------"
  end


  task :reset_task, [:task_id] => :environment do |t, args| 
    STDOUT.print "This action will remove the task. Are you sure? [y/n] :"
    STDOUT.flush
    i = STDIN.gets.strip
    if i =~ /[Yy].*/
      Task.find(args[:task_id]).reset
    end
  end

  namespace :mturk do

    desc "Test Mturk API Calls"
    task :test => :environment do
      @mturk = Amazon::WebServices::MechanicalTurkRequester.new
      puts "I have $#{@mturk.availableFunds} in Sandbox"
    end

    desc "Disables all sandbox HITs (100 at a time)"
    task :clear_sandbox => :environment do
      r = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
      hits = r.searchHITs({PageSize: 100})[:HIT]
      if hits
        hits.each{|h| r.disableHIT({HITId: h[:HITId]})}
      end
    end

    desc "Inspect hit for given task"
    task :getHit, [:task_key] => :environment do |t, args|
      jwt = JWT.decode(args[:task_key], ENV["IL_SECRET"])
      task = Task.find(jwt[0]['task_id'])
      pp task.mturk_hit
    end


  end


end
