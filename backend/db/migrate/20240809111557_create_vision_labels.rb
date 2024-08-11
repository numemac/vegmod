class CreateVisionLabels < ActiveRecord::Migration[7.1]
  def change
    create_table :vision_labels do |t|
      t.references :context, polymorphic: true, null: false
      t.string :label, null: false
      t.string :value, null: false
      t.timestamps
    end
  end
end
