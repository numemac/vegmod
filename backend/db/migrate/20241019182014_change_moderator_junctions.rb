class ChangeModeratorJunctions < ActiveRecord::Migration[7.1]
  def change
    rename_table :x_moderators, :moderator_redditors

    unless index_exists?(:moderator_redditors, [:moderator_id, :redditor_id])
      add_index :moderator_redditors, [:moderator_id, :redditor_id], unique: true
    end

    unless index_exists?(:moderator_subreddits, [:moderator_id, :subreddit_id])
      add_index :moderator_subreddits, [:moderator_id, :subreddit_id], unique: true
    end
  end
end
