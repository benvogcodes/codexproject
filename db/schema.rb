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

ActiveRecord::Schema.define(version: 20150924222500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "plans", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "frequency"
    t.string   "topic"
    t.string   "language"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "cards_per_serve"
    t.integer  "serves"
    t.string   "name"
    t.integer  "served"
    t.boolean  "twilio"
    t.boolean  "sendgrid"
    t.integer  "phone_number"
  end

  add_index "plans", ["user_id"], name: "index_plans_on_user_id", using: :btree

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
    t.string   "name"
    t.string   "user"
    t.datetime "created"
    t.datetime "updated"
    t.datetime "pushed"
    t.string   "watchers"
  end

  add_index "repos", ["plan_id"], name: "index_repos_on_plan_id", using: :btree

  create_table "servings", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "repo_id"
    t.integer "delivery"
  end

  add_index "servings", ["plan_id"], name: "index_servings_on_plan_id", using: :btree
  add_index "servings", ["repo_id"], name: "index_servings_on_repo_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "phone"
  end

  add_foreign_key "plans", "users"
  add_foreign_key "repos", "plans"
  add_foreign_key "servings", "plans"
  add_foreign_key "servings", "repos"
end
