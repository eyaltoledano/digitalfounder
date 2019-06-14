class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :name
      t.text :description
      t.string :version_number
      t.string :release_number
      t.string :status
      t.string :progress
      t.string :release_date
      t.integer :product_id
      t.timestamps null: false
    end
  end
end
