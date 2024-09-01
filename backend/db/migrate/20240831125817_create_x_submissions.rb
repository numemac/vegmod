class CreateXSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :x_submissions do |t|
      t.references :submission, null: false, foreign_key: true
      t.boolean :bot_disabled, default: false
      t.timestamps
    end

    create_table :x_comments do |t|
      t.references :comment, null: false, foreign_key: true
      t.references :submission, null: true, foreign_key: true
      t.timestamps
    end
  end
end
