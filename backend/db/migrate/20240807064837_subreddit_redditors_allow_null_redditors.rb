class SubredditRedditorsAllowNullRedditors < ActiveRecord::Migration[7.1]
  def change
    # allow redditor_id foreign key to be null on subreddit_redditors
    change_column :subreddit_redditors, :redditor_id, :integer, null: true
  end
end
