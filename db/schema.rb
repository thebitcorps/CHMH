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

ActiveRecord::Schema.define(version: 20150420213112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["user_id"], name: "index_areas_on_user_id", using: :btree

  create_table "examineds", force: true do |t|
    t.integer  "user_id"
    t.integer  "procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedures", force: true do |t|
    t.string   "folio"
    t.date     "donedate"
    t.integer  "minutes"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "surgery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "procedures", ["surgery_id"], name: "index_procedures_on_surgery_id", using: :btree
  add_index "procedures", ["user_id"], name: "index_procedures_on_user_id", using: :btree

  create_table "seasons", force: true do |t|
    t.date     "startdate"
    t.date     "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgeries", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "surgeries", ["area_id"], name: "index_surgeries_on_area_id", using: :btree

  create_table "task_procedures", force: true do |t|
    t.integer  "procedure_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_procedures", ["procedure_id"], name: "index_task_procedures_on_procedure_id", using: :btree
  add_index "task_procedures", ["task_id"], name: "index_task_procedures_on_task_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "surgery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["surgery_id"], name: "index_tasks_on_surgery_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "season_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "lastname"
    t.date     "birthday"
    t.string   "role"
    t.string   "gender",                 limit: 1
    t.integer  "minutes"
  end

  add_index "users", ["area_id"], name: "index_users_on_area_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["season_id"], name: "index_users_on_season_id", using: :btree

end
