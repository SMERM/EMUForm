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

  create_table "author_work_roles", force: :cascade do |t|
    t.integer  "author_id",  null: false
    t.integer  "work_id",    null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.integer  "birth_year"
    t.text     "bio_en"
    t.text     "bio_it"
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
