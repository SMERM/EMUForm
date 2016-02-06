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

ActiveRecord::Schema.define(version: 20160128210326) do

  create_table "accounts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "location"
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "accounts", ["authentication_token"], name: "index_accounts_on_authentication_token", unique: true
  add_index "accounts", ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_type",      null: false
    t.integer  "resource_id",        null: false
    t.integer  "admin_account_id"
    t.string   "admin_account_type"
    t.string   "namespace"
    t.text     "body"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "active_admin_comments", ["admin_account_id"], name: "index_active_admin_comments_on_admin_account_id"
  add_index "active_admin_comments", ["admin_account_type"], name: "index_active_admin_comments_on_admin_account_type"
  add_index "active_admin_comments", ["resource_id"], name: "index_active_admin_comments_on_resource_id"
  add_index "active_admin_comments", ["resource_type"], name: "index_active_admin_comments_on_resource_type"

  create_table "admin_accounts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "location"
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_accounts", ["authentication_token"], name: "index_admin_accounts_on_authentication_token", unique: true
  add_index "admin_accounts", ["confirmation_token"], name: "index_admin_accounts_on_confirmation_token", unique: true
  add_index "admin_accounts", ["email"], name: "index_admin_accounts_on_email", unique: true
  add_index "admin_accounts", ["reset_password_token"], name: "index_admin_accounts_on_reset_password_token", unique: true

  create_table "author_work_roles", force: :cascade do |t|
    t.integer  "author_id",  null: false
    t.integer  "work_id",    null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.string   "account_name"
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.integer  "birth_year"
    t.text     "bio_en"
    t.text     "bio_it"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.boolean  "static",      default: false, null: false
    t.string   "description",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "roles", ["description"], name: "index_roles_on_description"

  create_table "submitted_files", force: :cascade do |t|
    t.string   "filename",     null: false
    t.string   "content_type", null: false
    t.integer  "size",         null: false
    t.integer  "work_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "works", force: :cascade do |t|
    t.string   "title",            null: false
    t.datetime "year",             null: false
    t.datetime "duration",         null: false
    t.string   "instruments",      null: false
    t.text     "program_notes_en", null: false
    t.text     "program_notes_it"
    t.string   "directory"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
