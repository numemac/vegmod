class RemoveSubredditAndRedditorIdColumnsFromSubmissionsAndComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :submissions, :subreddit_id
    remove_column :submissions, :redditor_id

    remove_column :comments, :subreddit_id
    remove_column :comments, :redditor_id

    # add indexes on subreddit_redditor references for comments and submissions
    add_index :comments, :subreddit_redditor_id unless index_exists?(:comments, :subreddit_redditor_id)
    add_index :submissions, :subreddit_redditor_id unless index_exists?(:submissions, :subreddit_redditor_id)
  end
end
