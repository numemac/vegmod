class AddOrderNotNullToWidgets < ActiveRecord::Migration[7.1]
  def change
    # change order column so it cannot be null
    change_column_null :widgets, :order, false
  end
end
