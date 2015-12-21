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

ActiveRecord::Schema.define(version: 20151218154100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.integer  "repository_id",                     null: false
    t.integer  "author_id"
    t.integer  "reviewer_id"
    t.string   "state",         default: "pending", null: false
    t.datetime "opened_at",                         null: false
    t.datetime "assigned_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "title",                             null: false
    t.text     "body",                              null: false
    t.integer  "github_id"
    t.integer  "issue_number"
    t.string   "url"
    t.string   "head_sha"
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.string   "git_url"
    t.string   "html_url"
    t.string   "owner"
    t.boolean  "synchronized", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "github_id"
    t.string   "full_name"
  end

  add_index "repositories", ["github_id"], name: "index_repositories_on_github_id", using: :btree

  create_table "repository_reviewers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "repository_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "name",                   default: "",    null: false
    t.string   "slack_username"
    t.string   "github_access_token"
    t.integer  "github_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
