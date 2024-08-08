class AddRemovalReasons < ActiveRecord::Migration[7.1]
  def change
    add_reference :reports, :subreddit, null: false, foreign_key: true

    create_table :removal_reasons do |t|
      t.references :subreddit, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :title, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
