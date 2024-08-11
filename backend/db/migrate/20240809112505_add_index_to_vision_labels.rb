class AddIndexToVisionLabels < ActiveRecord::Migration[7.1]
  def change
    # add index to vision_labels, context (polymorphic) + label should be unique
    add_index :vision_labels, [:context_type, :context_id, :label], unique: true
  end
end
