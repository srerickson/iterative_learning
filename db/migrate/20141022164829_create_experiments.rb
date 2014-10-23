class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.string  :name
      t.text    :description

      # t.integer :num_conditions, default: 1
      t.integer :chains_per_condition, default: 1
      t.integer :generations_per_chain, default: 1
      t.integer :tasks_per_generation, default: 1

      t.integer :percent_test_for_training, default: 50
      t.boolean :generation_shared_values

      t.boolean :is_mturk, default: false
      t.string  :mturk_title
      t.text    :mturk_description
      t.string  :mutkr_keywords
      t.integer :mturk_award # USD
      t.integer :mturk_time_to_complete
      t.integer :mturk_time_to_expire
      t.string  :mturk_qualifications

      t.timestamps
    end

    create_table :conditions do |t|
      t.integer :experiment_id
      t.json    :start_values, default: []
      t.json    :target_values, default: []
    end

    create_table :chains do |t|
      t.integer :condition_id
    end

    create_table :generations do |t|
      t.integer :chain_id
      t.json    :start_values, default: []
    end

    create_table :tasks do |t|
      t.integer :generation_id
      t.string  :worker_mturk_id
      t.integer :worker_age
      t.string  :worker_gender
      t.json    :response
      t.timestamps
    end

  end

  def self.down
    drop_table :experiments
    drop_table :conditions
    drop_table :chains
    drop_table :generations
    drop_table :tasks
  end
end
