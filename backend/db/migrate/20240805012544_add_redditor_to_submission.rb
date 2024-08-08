class AddRedditorToSubmission < ActiveRecord::Migration[7.1]
  def change
    remove_column :submissions, :author_id
    remove_column :comments, :author_id

    add_reference :submissions, :redditor, null: false, foreign_key: true
    add_reference :comments, :redditor, null: false, foreign_key: true
  end
end
