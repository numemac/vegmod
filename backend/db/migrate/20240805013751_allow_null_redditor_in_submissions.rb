class AllowNullRedditorInSubmissions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :submissions, :redditor, null: false, foreign_key: true
    add_reference :submissions, :redditor, null: true, foreign_key: true

    remove_reference :comments, :redditor, null: false, foreign_key: true
    add_reference :comments, :redditor, null: true, foreign_key: true
  end
end
