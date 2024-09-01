class CreateSubredditRules < ActiveRecord::Migration[7.1]
  def change
    create_table :rules do |t|
      t.references :subreddit, null: false, foreign_key: true
      t.float :created_utc
      t.text :description
      t.string :kind
      t.integer :priority
      t.string :short_name
      t.string :violation_reason
      t.timestamps

      t.index [:subreddit_id, :priority], unique: true
    end
  end
end
