class RemoveOrderIndexFromWidgets < ActiveRecord::Migration[7.1]
  def change
    # remove unique key on [:subreddit_id, :order]
    remove_index :widgets, column: [:subreddit_id, :order]
  end
end
