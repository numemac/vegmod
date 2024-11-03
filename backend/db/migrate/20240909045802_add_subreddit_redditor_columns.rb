class AddSubredditRedditorColumns < ActiveRecord::Migration[7.1]
  def change
    # add columns 'last_contributed_at' and 'score_30d'
    add_column :subreddit_redditors, :last_contributed_at, :datetime, null: true
    add_column :subreddit_redditors, :score_30d, :integer, null: false, default: 0
  end
end
