class AddPrLinkToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :pr_link, :string
  end
end
