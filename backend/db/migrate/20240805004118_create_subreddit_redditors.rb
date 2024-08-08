class CreateSubredditRedditors < ActiveRecord::Migration[7.1]
  def change
    # rename tables: subreddit, redditor, submission, comment, flair_template to plural
    rename_table :subreddit, :subreddits
    rename_table :redditor, :redditors
    rename_table :submission, :submissions
    rename_table :comment, :comments
    rename_table :flair_template, :flair_templates
    
    # junction table associating subreddits with redditors
    create_table :subreddit_redditors do |t|
      t.references :subreddit, null: false, foreign_key: true
      t.references :redditor, null: false, foreign_key: true
      t.index [:subreddit_id, :redditor_id], unique: true
      t.timestamps
    end
  end
end
