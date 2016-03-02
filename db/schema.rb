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

ActiveRecord::Schema.define(version: 20160301163924) do

  create_table "contribution_ranking_versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contribution_rankings", force: :cascade do |t|
    t.integer  "contribution_ranking_version_id", limit: 4
    t.integer  "qiita_user_id",                   limit: 4
    t.string   "name",                            limit: 255
    t.integer  "contributions",                   limit: 4
    t.integer  "rank",                            limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "contribution_rankings", ["name", "contribution_ranking_version_id"], name: "name_version_index", using: :btree
  add_index "contribution_rankings", ["rank", "contribution_ranking_version_id"], name: "rank_version_index", using: :btree

  create_table "qiita_users", force: :cascade do |t|
    t.string   "name",          limit: 255,                 null: false
    t.integer  "followers",     limit: 4
    t.integer  "items",         limit: 4
    t.integer  "contributions", limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "error",                     default: false
  end

  add_index "qiita_users", ["contributions"], name: "index_qiita_users_on_contributions", using: :btree
  add_index "qiita_users", ["name"], name: "index_qiita_users_on_name", unique: true, using: :btree

end
