class CreateXRedditors < ActiveRecord::Migration[7.1]
  def change
    create_table :x_redditors do |t|
      t.references :redditor, null: false, foreign_key: true
      t.integer :score, null: false, default: 0
      t.integer :adversarial_score, null: false, default: 0
      t.integer :non_adversarial_score, null: false, default: 0
      t.timestamps
    end
  end
end
