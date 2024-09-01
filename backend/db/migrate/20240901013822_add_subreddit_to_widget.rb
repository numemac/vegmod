class AddSubredditToWidget < ActiveRecord::Migration[7.1]
  def change
    add_reference :widgets, :subreddit, null: false, foreign_key: true
  end
end
