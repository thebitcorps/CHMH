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

ActiveRecord::Schema.define(version: 20170728045721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["user_id"], name: "index_areas_on_user_id", using: :btree

  create_table "examineds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "procedures", force: :cascade do |t|
    t.string   "folio",      limit: 255
    t.date     "donedate"
    t.integer  "minutes"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "surgery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "examined",               default: false
  end

  add_index "procedures", ["surgery_id"], name: "index_procedures_on_surgery_id", using: :btree
  add_index "procedures", ["user_id"], name: "index_procedures_on_user_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.date     "startdate"
    t.date     "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgeries", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "surgeries", ["area_id"], name: "index_surgeries_on_area_id", using: :btree

  create_table "task_procedures", force: :cascade do |t|
    t.integer  "procedure_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_procedures", ["procedure_id"], name: "index_task_procedures_on_procedure_id", using: :btree
  add_index "task_procedures", ["task_id"], name: "index_task_procedures_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "surgery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["surgery_id"], name: "index_tasks_on_surgery_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "season_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "lastname",               limit: 255
    t.date     "birthday"
    t.string   "role",                   limit: 255
    t.string   "gender",                 limit: 1
    t.integer  "minutes"
    t.integer  "access_level"
    t.integer  "sex"
  end

  add_index "users", ["area_id"], name: "index_users_on_area_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["season_id"], name: "index_users_on_season_id", using: :btree

end
