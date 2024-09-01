class CreateWidgets < ActiveRecord::Migration[7.1]
  def change
    create_table :widgets do |t|
      t.string :external_id, null: false
      t.string :kind, null: false
      t.string :short_name, null: false
      t.timestamps

      t.index :external_id, unique: true
    end

    create_table :widget_styles do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :background_color
      t.string :header_color
      t.timestamps
    end

    create_table :id_cards do |t|
      t.references :widget, null: false, foreign_key: true
      t.integer :currently_viewing_count
      t.string :currently_viewing_text
      t.string :description
      t.integer :subscribers_count
      t.string :subscribers_text
      t.timestamps
    end

    create_table :community_lists do |t|
      t.references :widget, null: false, foreign_key: true
      t.timestamps
    end

    create_table :community_list_subreddits do |t|
      t.references :community_list, null: false, foreign_key: true
      t.references :subreddit, null: false, foreign_key: true
      t.timestamps
    end

    create_table :button_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :description
      t.string :description_html
      t.timestamps
    end

    create_table :buttons do |t|
      t.references :button_widget, null: false, foreign_key: true
      t.string :color
      t.string :fill_color
      t.integer :height
      t.string :kind
      t.string :link_url
      t.string :text
      t.string :text_color
      t.string :url
      t.integer :width
      t.timestamps
    end

    create_table :button_hover_states do |t|
      t.references :button, null: false, foreign_key: true
      t.string :kind
      t.string :text
      t.string :color 
      t.string :text_color
      t.string :fill_color
      t.timestamps
    end

    create_table :custom_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :css
      t.integer :height
      t.string :stylesheet_url
      t.string :text
      t.string :text_html
      t.timestamps
    end

    create_table :image_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.timestamps
    end

    create_table :images do |t|
      t.references :image_widget, null: false, foreign_key: true
      t.integer :height
      t.string :link_url
      t.string :url
      t.integer :width
      t.timestamps

      t.index :url, unique: true
    end

    create_table :moderators_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.integer :total_mods
      t.timestamps
    end

    create_table :moderators_widget_redditors do |t|
      t.references :moderators_widget, null: false, foreign_key: true
      t.references :redditor, null: false, foreign_key: true
      t.index [:moderators_widget_id, :redditor_id], unique: true
      t.timestamps
    end

    create_table :post_flair_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :display
      t.json :templates
      t.timestamps
    end

    create_table :rules_widgets do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :display
      t.timestamps
    end

    create_table :rules_widget_rules do |t|
      t.references :rules_widget, null: false, foreign_key: true
      t.references :rule, null: false, foreign_key: true
      t.index [:rules_widget_id, :rule_id], unique: true
      t.timestamps
    end

    create_table :text_areas do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :text
      t.string :text_html
      t.timestamps
    end
  end
end
