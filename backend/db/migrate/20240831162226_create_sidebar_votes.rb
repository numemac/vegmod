class CreateSidebarVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :sidebar_votes do |t|
      t.references :subreddit_redditor, null: false, foreign_key: true
      t.references :submission, null: false, foreign_key: true
      t.timestamps
    end
  end
end
