class AddSubredditToFlairTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :flair_templates, :subreddit, null: false, foreign_key: true
  end
end
