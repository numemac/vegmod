class AddModeratorToSubredditRedditors < ActiveRecord::Migration[7.1]
  def change
    # add moderator bool flag to subreddit_redditors table
    # default to false
    add_column :subreddit_redditors, :moderator, :boolean, default: false

    # add index on moderator column
    add_index :subreddit_redditors, :moderator
  end
end
