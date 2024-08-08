class AddParentToComments < ActiveRecord::Migration[7.1]
  def change
    rename_column :comments, :parent_id, :parent_external_id
    add_reference :comments, :parent, polymorphic: true, index: true, null: true
  end
end
