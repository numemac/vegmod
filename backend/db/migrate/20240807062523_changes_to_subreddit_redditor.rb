class ChangesToSubredditRedditor < ActiveRecord::Migration[7.1]
  def change
    # add column score to subreddit_redditors
    add_column :subreddit_redditors, :score, :integer, default: 0

    # add subreddit_redditor foreign key to comments and submissions
    add_reference :comments, :subreddit_redditor, foreign_key: true
    add_reference :submissions, :subreddit_redditor, foreign_key: true
  end
end
