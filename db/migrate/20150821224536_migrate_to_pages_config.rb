class MigrateToPagesConfig < ActiveRecord::Migration
  def self.up
    Experiment.all.each do |e|
      next if !!e.config['pages']
      intro_help_text = e.config.delete('intro_help_text')
      testing_intro = e.config.delete('testing_help_text')
      e.config['pages'] = {
        intro: {body: intro_help_text},
        testing_intro: {body: testing_intro}
      }
      e.config['sequence'] = ['intro','_training','testing_intro','_testing']
      e.save
    end
  end

  def self.down
    Experiment.all.each do |e|
      next if !e.config['pages']
      intro_help_text   = e.config['pages']['intro']['body']
      testing_help_text = e.config['pages']['testing_intro']['body']
      e.config.delete('pages')
      e.config.delete('sequence')
      e.config['intro_help_text'] = intro_help_text
      e.config['testing_help_text'] = testing_help_text
      e.save
    end

  end
end
