class AddSubredditKeyToComments < ActiveRecord::Migration[7.1]
  def change
    rename_column :comments, :subreddit_id, :subreddit_external_id
    add_reference :comments, :subreddit, null: false, foreign_key: true
  end
end
