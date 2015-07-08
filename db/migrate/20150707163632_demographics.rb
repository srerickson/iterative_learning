class Demographics < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :worker_age
    remove_column :tasks, :worker_gender
    add_column :tasks, :demographics, :text, default: "{}"
  end

  def self.down
    add_column :tasks, :worker_age, :string
    add_column :tasks, :worker_gender, :string
    remove_column :tasks, :demographics
  end
end
