class CreateScripts < ActiveRecord::Migration[7.1]
  def change
    create_table :plugins do |t|
      t.string  :klass, null: false
      t.string  :title, null: false
      t.string  :description, null: false
      t.string  :author, null: false
      t.jsonb   :spec, default: {}
      t.boolean :loaded, default: false
      t.timestamps

      t.index :klass, unique: true
    end

    create_table :subreddit_plugins do |t|
      t.references  :subreddit, null: false, foreign_key: true
      t.references  :plugin, null: false, foreign_key: true
      t.boolean     :enabled, default: true
      t.jsonb       :config, default: {}
      t.integer     :executions, default: 0
      t.integer     :failures, default: 0
      t.datetime    :last_executed_at, default: nil
      t.datetime    :last_failed_at, default: nil
      t.timestamps

      t.index [:subreddit_id, :plugin_id], unique: true
    end

    create_table :logs do |t|
      t.references  :loggable, polymorphic: true, null: false
      t.string      :level, null: false
      t.string      :message, null: false
      t.timestamps
    end
  end
end
