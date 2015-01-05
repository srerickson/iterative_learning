require 'yaml'

namespace :il do 

  task :build => :environment do 
    Experiment.build_from_config(ENV['EXP_FILE'] || 'config/experiments.yml')
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
