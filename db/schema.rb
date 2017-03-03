# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170303024054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "author"
    t.string   "kind"
    t.date     "published_at"
    t.string   "image"
    t.string   "youtube_url"
    t.string   "youtube_id"
    t.string   "link"
    t.text     "description"
    t.boolean  "published",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "fb_ia_content"
    t.string   "system_type"
    t.string   "youtube_list_id"
  end

  create_table "articles_keywords", id: false, force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "keyword_id", null: false
  end

  add_index "articles_keywords", ["article_id", "keyword_id"], name: "index_articles_keywords_on_article_id_and_keyword_id", unique: true, using: :btree

  create_table "catalogs", force: :cascade do |t|
    t.string  "name"
    t.string  "image"
    t.boolean "published", default: true
    t.integer "position"
  end

  add_index "catalogs", ["name"], name: "index_catalogs_on_name", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "catalog_id"
    t.boolean "published",  default: true
    t.integer "position"
    t.integer "width",      default: 1,    null: false
  end

  add_index "categories", ["catalog_id"], name: "index_categories_on_catalog_id", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.integer "keyword_id"
    t.string  "question"
    t.text    "answer"
    t.integer "position",   default: 0, null: false
  end

  add_index "faqs", ["keyword_id"], name: "index_faqs_on_keyword_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string  "name"
    t.integer "category_id"
    t.boolean "showed",        default: false
    t.boolean "published",     default: true
    t.string  "image"
    t.string  "cover"
    t.string  "title"
    t.text    "description"
    t.text    "content"
    t.integer "position"
    t.integer "show_position", default: 0,     null: false
    t.string  "label"
    t.string  "label_type"
  end

  add_index "keywords", ["category_id"], name: "index_keywords_on_category_id", using: :btree
  add_index "keywords", ["name"], name: "index_keywords_on_name", unique: true, using: :btree

  create_table "slides", force: :cascade do |t|
    t.integer "position"
    t.integer "slideable_id"
    t.string  "slideable_type"
    t.string  "image"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "provider_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
