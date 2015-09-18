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

ActiveRecord::Schema.define(version: 20150918184542) do

  create_table "plans", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "frequency"
    t.string   "topic"
    t.string   "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plans", ["user_id"], name: "index_plans_on_user_id"

  create_table "repos", force: :cascade do |t|
    t.integer  "plan_id"
    t.boolean  "served"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "url"
    t.integer  "stars"
    t.integer  "forks"
    t.integer  "size"
    t.text     "desc"
  end

  add_index "repos", ["plan_id"], name: "index_repos_on_plan_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "phone"
  end

end
