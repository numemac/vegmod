# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_31_134314) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "button_hover_states", force: :cascade do |t|
    t.bigint "button_id", null: false
    t.string "kind"
    t.string "text"
    t.string "color"
    t.string "text_color"
    t.string "fill_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["button_id"], name: "index_button_hover_states_on_button_id"
  end

  create_table "button_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "description"
    t.string "description_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_button_widgets_on_widget_id"
  end

  create_table "buttons", force: :cascade do |t|
    t.bigint "button_widget_id", null: false
    t.string "color"
    t.string "fill_color"
    t.integer "height"
    t.string "kind"
    t.string "link_url"
    t.string "text"
    t.string "text_color"
    t.string "url"
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["button_widget_id"], name: "index_buttons_on_button_widget_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.text "body_html"
    t.float "created_utc"
    t.boolean "distinguished"
    t.boolean "edited"
    t.string "external_id", null: false
    t.boolean "is_submitter"
    t.string "link_id"
    t.string "parent_external_id"
    t.string "permalink"
    t.integer "score"
    t.boolean "stickied"
    t.string "subreddit_external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "parent_type"
    t.bigint "parent_id"
    t.bigint "subreddit_redditor_id"
    t.index ["external_id"], name: "index_comments_on_external_id", unique: true
    t.index ["parent_type", "parent_id"], name: "index_comments_on_parent"
    t.index ["subreddit_redditor_id"], name: "index_comments_on_subreddit_redditor_id"
  end

  create_table "community_list_subreddits", force: :cascade do |t|
    t.bigint "community_list_id", null: false
    t.bigint "subreddit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_list_id"], name: "index_community_list_subreddits_on_community_list_id"
    t.index ["subreddit_id"], name: "index_community_list_subreddits_on_subreddit_id"
  end

  create_table "community_lists", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_community_lists_on_widget_id"
  end

  create_table "custom_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "css"
    t.integer "height"
    t.string "stylesheet_url"
    t.string "text"
    t.string "text_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_custom_widgets_on_widget_id"
  end

  create_table "flair_templates", force: :cascade do |t|
    t.string "allowable_content"
    t.string "text"
    t.string "text_color"
    t.boolean "mod_only"
    t.string "background_color"
    t.string "external_id", null: false
    t.string "css_class"
    t.integer "max_emojis"
    t.json "richtext"
    t.boolean "text_editable"
    t.boolean "override_css"
    t.string "external_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_id", null: false
    t.index ["external_id"], name: "index_flair_templates_on_external_id", unique: true
    t.index ["subreddit_id"], name: "index_flair_templates_on_subreddit_id"
  end

  create_table "id_cards", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.integer "currently_viewing_count"
    t.string "currently_viewing_text"
    t.string "description"
    t.integer "subscribers_count"
    t.string "subscribers_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_id_cards_on_widget_id"
  end

  create_table "image_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_image_widgets_on_widget_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "image_widget_id", null: false
    t.integer "height"
    t.string "link_url"
    t.string "url"
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["image_widget_id", "order"], name: "index_images_on_image_widget_id_and_order", unique: true
    t.index ["image_widget_id"], name: "index_images_on_image_widget_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "loggable_type", null: false
    t.bigint "loggable_id", null: false
    t.string "level", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loggable_type", "loggable_id"], name: "index_logs_on_loggable"
  end

  create_table "metric_subject_data_points", force: :cascade do |t|
    t.bigint "metric_subject_id", null: false
    t.datetime "interval_start", null: false
    t.decimal "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_subject_id", "interval_start"], name: "idx_on_metric_subject_id_interval_start_0d6e0d6cf7", unique: true
    t.index ["metric_subject_id"], name: "index_metric_subject_data_points_on_metric_subject_id"
  end

  create_table "metric_subjects", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id", "subject_id", "subject_type"], name: "idx_on_metric_id_subject_id_subject_type_1e7105d238", unique: true
    t.index ["metric_id"], name: "index_metric_subjects_on_metric_id"
    t.index ["subject_type", "subject_id"], name: "index_metric_subjects_on_subject"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "measure", null: false
    t.string "unit"
    t.integer "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure", "unit", "interval"], name: "index_metrics_on_measure_and_unit_and_interval", unique: true
  end

  create_table "moderators_widget_redditors", force: :cascade do |t|
    t.bigint "moderators_widget_id", null: false
    t.bigint "redditor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moderators_widget_id", "redditor_id"], name: "idx_on_moderators_widget_id_redditor_id_1ed135e74f", unique: true
    t.index ["moderators_widget_id"], name: "index_moderators_widget_redditors_on_moderators_widget_id"
    t.index ["redditor_id"], name: "index_moderators_widget_redditors_on_redditor_id"
  end

  create_table "moderators_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.integer "total_mods"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_moderators_widgets_on_widget_id"
  end

  create_table "plugins", force: :cascade do |t|
    t.string "klass", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "author", null: false
    t.jsonb "spec", default: {}
    t.boolean "loaded", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klass"], name: "index_plugins_on_klass", unique: true
  end

  create_table "post_flair_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "display"
    t.json "templates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_post_flair_widgets_on_widget_id"
  end

  create_table "praw_logs", force: :cascade do |t|
    t.string "action"
    t.string "context_type"
    t.bigint "context_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_type", "context_id"], name: "index_praw_logs_on_context"
  end

  create_table "redditors", force: :cascade do |t|
    t.integer "comment_karma"
    t.float "created_utc"
    t.boolean "has_verified_email"
    t.string "icon_img"
    t.string "external_id", null: false
    t.boolean "is_employee"
    t.boolean "is_mod"
    t.boolean "is_gold"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_redditors_on_external_id", unique: true
    t.index ["name"], name: "index_redditors_on_name", unique: true
  end

  create_table "removal_reasons", force: :cascade do |t|
    t.bigint "subreddit_id", null: false
    t.string "external_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subreddit_id"], name: "index_removal_reasons_on_subreddit_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "content_external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_id", null: false
    t.string "content_type"
    t.bigint "content_id"
    t.index ["content_type", "content_id"], name: "index_reports_on_content"
    t.index ["content_type", "content_id"], name: "index_reports_on_content_type_and_content_id", unique: true
    t.index ["subreddit_id"], name: "index_reports_on_subreddit_id"
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "subreddit_id", null: false
    t.float "created_utc"
    t.text "description"
    t.string "kind"
    t.integer "priority"
    t.string "short_name"
    t.string "violation_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subreddit_id", "priority"], name: "index_rules_on_subreddit_id_and_priority", unique: true
    t.index ["subreddit_id"], name: "index_rules_on_subreddit_id"
  end

  create_table "rules_widget_rules", force: :cascade do |t|
    t.bigint "rules_widget_id", null: false
    t.bigint "rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_rules_widget_rules_on_rule_id"
    t.index ["rules_widget_id", "rule_id"], name: "index_rules_widget_rules_on_rules_widget_id_and_rule_id", unique: true
    t.index ["rules_widget_id"], name: "index_rules_widget_rules_on_rules_widget_id"
  end

  create_table "rules_widgets", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "display"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_rules_widgets_on_widget_id"
  end

  create_table "sidebar_votes", force: :cascade do |t|
    t.bigint "subreddit_redditor_id", null: false
    t.bigint "submission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["submission_id"], name: "index_sidebar_votes_on_submission_id"
    t.index ["subreddit_redditor_id"], name: "index_sidebar_votes_on_subreddit_redditor_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "author_flair_text"
    t.float "created_utc"
    t.string "distinguished"
    t.boolean "edited"
    t.string "external_id", null: false
    t.boolean "is_original_content"
    t.boolean "is_self"
    t.string "link_flair_template_id"
    t.string "link_flair_text"
    t.boolean "locked"
    t.string "name"
    t.integer "num_comments"
    t.boolean "over_18"
    t.string "permalink"
    t.integer "poll_data_id"
    t.integer "score"
    t.string "selftext"
    t.boolean "spoiler"
    t.boolean "stickied"
    t.string "title"
    t.float "upvote_ratio"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_redditor_id"
    t.index ["external_id"], name: "index_submissions_on_external_id", unique: true
    t.index ["subreddit_redditor_id"], name: "index_submissions_on_subreddit_redditor_id"
  end

  create_table "subreddit_plugins", force: :cascade do |t|
    t.bigint "subreddit_id", null: false
    t.bigint "plugin_id", null: false
    t.boolean "enabled", default: true
    t.jsonb "config", default: {}, null: false
    t.integer "executions", default: 0
    t.integer "failures", default: 0
    t.datetime "last_executed_at"
    t.datetime "last_failed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plugin_id"], name: "index_subreddit_plugins_on_plugin_id"
    t.index ["subreddit_id", "plugin_id"], name: "index_subreddit_plugins_on_subreddit_id_and_plugin_id", unique: true
    t.index ["subreddit_id"], name: "index_subreddit_plugins_on_subreddit_id"
  end

  create_table "subreddit_redditors", force: :cascade do |t|
    t.bigint "subreddit_id", null: false
    t.integer "redditor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.datetime "last_contributed_at"
    t.integer "score_30d", default: 0, null: false
    t.string "fetch_column", null: false
    t.boolean "moderator", default: false
    t.index ["fetch_column"], name: "index_subreddit_redditors_on_fetch_column", unique: true
    t.index ["moderator"], name: "index_subreddit_redditors_on_moderator"
    t.index ["redditor_id"], name: "index_subreddit_redditors_on_redditor_id"
    t.index ["subreddit_id", "redditor_id"], name: "index_subreddit_redditors_on_subreddit_id_and_redditor_id", unique: true
    t.index ["subreddit_id"], name: "index_subreddit_redditors_on_subreddit_id"
  end

  create_table "subreddits", force: :cascade do |t|
    t.boolean "can_assign_link_flair"
    t.boolean "can_assign_user_flair"
    t.float "created_utc"
    t.text "description"
    t.text "description_html"
    t.string "display_name", null: false
    t.string "external_id", null: false
    t.string "name", null: false
    t.boolean "over18"
    t.text "public_description"
    t.boolean "spoilers_enabled"
    t.integer "subscribers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_discovery"
    t.string "banner_background_image"
    t.string "community_icon"
    t.boolean "hide_ads"
    t.boolean "public_traffic"
    t.string "title"
    t.integer "wls"
    t.boolean "adversarial", default: false
    t.index ["display_name"], name: "index_subreddits_on_display_name", unique: true
    t.index ["external_id"], name: "index_subreddits_on_external_id", unique: true
    t.index ["name"], name: "index_subreddits_on_name", unique: true
  end

  create_table "text_areas", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "text"
    t.string "text_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_text_areas_on_widget_id"
  end

  create_table "user_redditors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "redditor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["redditor_id"], name: "index_user_redditors_on_redditor_id"
    t.index ["user_id", "redditor_id"], name: "index_user_redditors_on_user_id_and_redditor_id", unique: true
    t.index ["user_id"], name: "index_user_redditors_on_user_id"
  end

  create_table "user_subreddits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subreddit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subreddit_id"], name: "index_user_subreddits_on_subreddit_id"
    t.index ["user_id", "subreddit_id"], name: "index_user_subreddits_on_user_id_and_subreddit_id", unique: true
    t.index ["user_id"], name: "index_user_subreddits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dark_mode", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vision_labels", force: :cascade do |t|
    t.string "context_type", null: false
    t.bigint "context_id", null: false
    t.string "label", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_type", "context_id", "label"], name: "index_vision_labels_on_context_type_and_context_id_and_label", unique: true
    t.index ["context_type", "context_id"], name: "index_vision_labels_on_context"
  end

  create_table "widget_styles", force: :cascade do |t|
    t.bigint "widget_id", null: false
    t.string "background_color"
    t.string "header_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_widget_styles_on_widget_id"
  end

  create_table "widgets", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "kind", null: false
    t.string "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_id", null: false
    t.integer "order", null: false
    t.index ["external_id"], name: "index_widgets_on_external_id", unique: true
    t.index ["subreddit_id"], name: "index_widgets_on_subreddit_id"
  end

  create_table "x_comments", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score_24h"
    t.index ["comment_id"], name: "index_x_comments_on_comment_id"
    t.index ["submission_id"], name: "index_x_comments_on_submission_id"
  end

  create_table "x_redditors", force: :cascade do |t|
    t.bigint "redditor_id", null: false
    t.integer "score", default: 0, null: false
    t.integer "adversarial_score", default: 0, null: false
    t.integer "non_adversarial_score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["redditor_id"], name: "index_x_redditors_on_redditor_id"
  end

  create_table "x_submissions", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.boolean "bot_disabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score_24h"
    t.index ["submission_id"], name: "index_x_submissions_on_submission_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "button_hover_states", "buttons"
  add_foreign_key "button_widgets", "widgets"
  add_foreign_key "buttons", "button_widgets"
  add_foreign_key "comments", "subreddit_redditors"
  add_foreign_key "community_list_subreddits", "community_lists"
  add_foreign_key "community_list_subreddits", "subreddits"
  add_foreign_key "community_lists", "widgets"
  add_foreign_key "custom_widgets", "widgets"
  add_foreign_key "flair_templates", "subreddits"
  add_foreign_key "id_cards", "widgets"
  add_foreign_key "image_widgets", "widgets"
  add_foreign_key "images", "image_widgets"
  add_foreign_key "moderators_widget_redditors", "moderators_widgets"
  add_foreign_key "moderators_widget_redditors", "redditors"
  add_foreign_key "moderators_widgets", "widgets"
  add_foreign_key "post_flair_widgets", "widgets"
  add_foreign_key "removal_reasons", "subreddits"
  add_foreign_key "reports", "subreddits"
  add_foreign_key "rules", "subreddits"
  add_foreign_key "rules_widget_rules", "rules"
  add_foreign_key "rules_widget_rules", "rules_widgets"
  add_foreign_key "rules_widgets", "widgets"
  add_foreign_key "sidebar_votes", "submissions"
  add_foreign_key "sidebar_votes", "subreddit_redditors"
  add_foreign_key "submissions", "subreddit_redditors"
  add_foreign_key "subreddit_plugins", "plugins"
  add_foreign_key "subreddit_plugins", "subreddits"
  add_foreign_key "subreddit_redditors", "redditors"
  add_foreign_key "subreddit_redditors", "subreddits"
  add_foreign_key "text_areas", "widgets"
  add_foreign_key "user_redditors", "redditors"
  add_foreign_key "user_redditors", "users"
  add_foreign_key "user_subreddits", "subreddits"
  add_foreign_key "user_subreddits", "users"
  add_foreign_key "widget_styles", "widgets"
  add_foreign_key "widgets", "subreddits"
  add_foreign_key "x_comments", "comments"
  add_foreign_key "x_comments", "submissions"
  add_foreign_key "x_redditors", "redditors"
  add_foreign_key "x_submissions", "submissions"
end
