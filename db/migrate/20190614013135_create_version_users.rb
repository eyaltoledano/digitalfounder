class CreateVersionUsers < ActiveRecord::Migration
  def change
    create_table :version_users do |t|
      t.integer :user_id
      t.integer :version_id
    end
  end
end
