class ChainValues < ActiveRecord::Migration
  def self.up
    add_column :chains, :start_values, :text, default: '[]'
    add_column :chains, :target_values, :text, default: '[]'
  end

  def self.down
    remove_column :chains, :start_values, :text, default: '[]'
    remove_column :chains, :target_values, :text, default: '[]'
  end
end
