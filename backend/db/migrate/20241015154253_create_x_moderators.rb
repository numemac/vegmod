class CreateXModerators < ActiveRecord::Migration[7.1]
  def change
    create_table :x_moderators do |t|
      t.references :moderator, null: false, foreign_key: true
      t.references :redditor, null: false, foreign_key: true
      t.timestamps
    end
  end
end
