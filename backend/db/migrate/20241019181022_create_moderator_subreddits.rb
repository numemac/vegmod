class CreateModeratorSubreddits < ActiveRecord::Migration[7.1]
  def change
    create_table :moderator_subreddits do |t|
      t.references :moderator, null: false, foreign_key: true
      t.references :subreddit, null: false, foreign_key: true
      t.timestamps
    end
  end
end
