class AddFetchColumnToSubredditRedditors < ActiveRecord::Migration[7.1]
  def change
    add_column :subreddit_redditors, :fetch_column, :string
    add_index :subreddit_redditors, :fetch_column, unique: true

    Reddit::SubredditRedditor.find_each do |subreddit_redditor|
      subreddit_redditor.set_fetch_column!
    end

    # set null false on column
    change_column_null :subreddit_redditors, :fetch_column, false
  end
end
