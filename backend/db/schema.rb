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

ActiveRecord::Schema[7.1].define(version: 2024_08_05_022854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "subreddit_id", null: false
    t.bigint "redditor_id"
    t.string "parent_type"
    t.bigint "parent_id"
    t.index ["external_id"], name: "index_comments_on_external_id", unique: true
    t.index ["parent_type", "parent_id"], name: "index_comments_on_parent"
    t.index ["redditor_id"], name: "index_comments_on_redditor_id"
    t.index ["subreddit_id"], name: "index_comments_on_subreddit_id"
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
    t.integer "content_type"
    t.integer "content_id"
    t.integer "content_external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_id", null: false
    t.index ["subreddit_id"], name: "index_reports_on_subreddit_id"
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
    t.boolean "selftext"
    t.boolean "spoiler"
    t.boolean "stickied"
    t.string "title"
    t.float "upvote_ratio"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subreddit_id", null: false
    t.bigint "redditor_id"
    t.index ["external_id"], name: "index_submissions_on_external_id", unique: true
    t.index ["redditor_id"], name: "index_submissions_on_redditor_id"
    t.index ["subreddit_id"], name: "index_submissions_on_subreddit_id"
  end

  create_table "subreddit_redditors", force: :cascade do |t|
    t.bigint "subreddit_id", null: false
    t.bigint "redditor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["display_name"], name: "index_subreddits_on_display_name", unique: true
    t.index ["external_id"], name: "index_subreddits_on_external_id", unique: true
    t.index ["name"], name: "index_subreddits_on_name", unique: true
  end

  add_foreign_key "comments", "redditors"
  add_foreign_key "comments", "subreddits"
  add_foreign_key "flair_templates", "subreddits"
  add_foreign_key "removal_reasons", "subreddits"
  add_foreign_key "reports", "subreddits"
  add_foreign_key "submissions", "redditors"
  add_foreign_key "submissions", "subreddits"
  add_foreign_key "subreddit_redditors", "redditors"
  add_foreign_key "subreddit_redditors", "subreddits"
end
