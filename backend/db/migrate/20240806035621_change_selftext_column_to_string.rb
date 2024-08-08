class ChangeSelftextColumnToString < ActiveRecord::Migration[7.1]
  def change
    change_column :submissions, :selftext, :string
  end
end
