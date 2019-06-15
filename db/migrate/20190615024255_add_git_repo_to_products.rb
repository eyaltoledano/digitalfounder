class AddGitRepoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :git_repo, :string
  end
end
