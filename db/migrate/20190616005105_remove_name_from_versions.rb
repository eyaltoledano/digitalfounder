class RemoveNameFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :name
  end
end
