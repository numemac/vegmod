class AddPolymorphicToReports < ActiveRecord::Migration[7.1]
  def change
    # remove content_id, and content_type columns
    remove_column :reports, :content_id
    remove_column :reports, :content_type

    # add polymorphic association
    add_reference :reports, :content, polymorphic: true, index: true
  end
end
