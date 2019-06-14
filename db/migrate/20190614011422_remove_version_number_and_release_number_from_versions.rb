class RemoveVersionNumberAndReleaseNumberFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :version_number
    remove_column :versions, :release_number
    remove_column :versions, :status
  end
end
