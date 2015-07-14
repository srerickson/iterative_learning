class ExperimentConfigField < ActiveRecord::Migration
  def change
    rename_column :experiments, :frontend_config, :config
  end
end
