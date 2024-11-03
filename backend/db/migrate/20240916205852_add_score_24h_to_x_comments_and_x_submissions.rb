class AddScore24hToXCommentsAndXSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :x_comments,     :score_24h, :integer, null: true
    add_column :x_submissions,  :score_24h, :integer, null: true
  end
end
