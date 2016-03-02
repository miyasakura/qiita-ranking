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
    t.integer  "contribution_ranking_version_id"
    t.integer  "qiita_user_id"
    t.string   "name"
    t.integer  "contributions"
    t.integer  "rank"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "contribution_rankings", ["name", "contribution_ranking_version_id"], name: "name_version_index"
  add_index "contribution_rankings", ["rank", "contribution_ranking_version_id"], name: "rank_version_index"

# Could not dump table "qiita_users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
