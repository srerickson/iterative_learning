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
      t.string  :mturk_keywords
      t.float   :mturk_award # USD
      t.integer :mturk_duration, default: "3600"
      t.integer :mturk_lifetime, default: "31536000"
      t.string  :mturk_qualifications
      t.boolean :mturk_sandbox, default: false

      t.text    :frontend_config, default: '{}'

      t.timestamps
    end

    create_table :conditions do |t|
      t.integer :experiment_id
      t.string  :name
      t.text    :start_values, default: '[]'
      t.text    :target_values, default: '[]'
    end

    create_table :chains do |t|
      t.integer :condition_id
    end

    create_table :generations do |t|
      t.integer :chain_id
      t.integer :position
      t.text    :start_values, default: '[]'
    end

    create_table :tasks do |t|
      t.integer :generation_id
      t.string  :mturk_worker_id
      t.string  :mturk_hit_id
      t.integer :worker_age
      t.string  :worker_gender
      t.text    :start_values, default: '[]'
      t.text    :response_values
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
