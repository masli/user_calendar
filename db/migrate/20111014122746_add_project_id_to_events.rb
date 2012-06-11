class AddProjectIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :project_id, :integer
    add_index :events, :project_id
  end

  def self.down
    remove_column :events, :project_id
  end

end
