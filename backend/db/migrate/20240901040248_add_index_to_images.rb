class AddIndexToImages < ActiveRecord::Migration[7.1]
  def change
    # inde_images_on_url
    remove_index :images, name: "index_images_on_url"

    # add integer column called order
    add_column :images, :order, :integer

    # add unique index on image_widget_id and order
    add_index :images, [:image_widget_id, :order], unique: true
  end
end
