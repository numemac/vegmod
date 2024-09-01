class AddCategoryToSidebarVotes < ActiveRecord::Migration[7.1]
  def change
    add_column :sidebar_votes, :category, :string, null: true
  end
end
