class ChangeModeratorToUser < ActiveRecord::Migration[7.1]
  def change
    # rename moderators to users
    rename_table :moderators, :users

    # rename moderator_subreddits to user_subreddits
    rename_table  :moderator_subreddits, :user_subreddits
    rename_column :user_subreddits, :moderator_id, :user_id

    # rename moderator_redditors to user_redditors
    rename_table  :moderator_redditors, :user_redditors
    rename_column :user_redditors, :moderator_id, :user_id
  end
end
