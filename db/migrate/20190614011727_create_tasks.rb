class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :reward
      t.integer :version_id
      t.integer :product_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
