# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210816092529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "author"
    t.string "kind"
    t.date "published_at"
    t.string "image"
    t.string "youtube_url"
    t.string "youtube_id"
    t.string "link"
    t.text "description"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "fb_ia_content"
    t.string "system_type"
    t.string "youtube_list_id"
  end

  create_table "articles_keywords", id: false, force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "keyword_id", null: false
    t.index ["article_id", "keyword_id"], name: "index_articles_keywords_on_article_id_and_keyword_id", unique: true
  end

  create_table "catalogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.boolean "published", default: true
    t.integer "position"
    t.index ["name"], name: "index_catalogs_on_name", unique: true
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "catalog_id"
    t.boolean "published", default: true
    t.integer "position"
    t.integer "width", default: 1, null: false
    t.index ["catalog_id"], name: "index_categories_on_catalog_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.integer "keyword_id"
    t.string "question"
    t.text "answer"
    t.integer "position", default: 0, null: false
    t.index ["keyword_id"], name: "index_faqs_on_keyword_id"
  end

  create_table "keywords", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.boolean "showed", default: false
    t.boolean "published", default: true
    t.string "image"
    t.string "cover"
    t.string "title"
    t.text "description"
    t.text "content"
    t.integer "position"
    t.integer "show_position", default: 0, null: false
    t.string "label"
    t.string "label_type"
    t.index ["category_id"], name: "index_keywords_on_category_id"
    t.index ["name"], name: "index_keywords_on_name", unique: true
  end

  create_table "sites", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.string "link"
    t.integer "position"
    t.boolean "published"
  end

  create_table "slides", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.integer "slideable_id"
    t.string "slideable_type"
    t.string "image"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "provider_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
