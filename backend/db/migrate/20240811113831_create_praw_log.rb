class CreatePrawLog < ActiveRecord::Migration[7.1]
  def change
    create_table :praw_logs do |t|
      t.string :action
      t.references :context, polymorphic: true
      t.timestamps
    end
  end
end
