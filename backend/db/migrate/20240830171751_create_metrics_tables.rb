class CreateMetricsTables < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.string  :measure, null: false
      t.string  :unit, null: true
      t.integer :interval, null: true
      t.timestamps

      t.index [:measure, :unit, :interval], unique: true
    end

    create_table :metric_subjects do |t|
      t.references :metric, null: false
      t.references :subject, polymorphic: true, null: false
      t.timestamps

      t.index [:metric_id, :subject_id, :subject_type], unique: true
    end

    create_table :metric_subject_data_points do |t|
      t.references :metric_subject, null: false
      t.datetime :interval_start, null: false
      t.decimal :value, null: false
      t.timestamps

      t.index [:metric_subject_id, :interval_start], unique: true
    end

  end
end
