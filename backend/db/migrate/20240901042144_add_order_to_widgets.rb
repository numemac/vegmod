class AddOrderToWidgets < ActiveRecord::Migration[7.1]
  def change
    Reddit::Widget.destroy_all
    add_column :widgets, :order, :integer
    add_index :widgets, [:subreddit_id, :order], unique: true
  end
end
