# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2013_10_23_210206) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sprints", force: :cascade do |t|
    t.string "sprint_name"
    t.date "end_date"
    t.float "team_size"
    t.float "working_days"
    t.float "pto_days"
    t.float "planned_velocity"
    t.float "actual_velocity"
    t.float "adopted_points"
    t.float "unplanned_points"
    t.float "found_points"
    t.float "partial_points"
    t.integer "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "note"
    t.float "code_coverage", default: 0.0
    t.integer "nr_manual_tests", default: 0
    t.integer "nr_automated_tests", default: 0
    t.index ["team_id"], name: "index_sprints_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "sprint_weeks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "owners"
    t.boolean "is_archived", default: false
    t.integer "test_certification", default: 0
    t.integer "day_of_week_for_meetings", default: 5
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  create_table "trello_accounts", force: :cascade do |t|
    t.string "public_key"
    t.string "read_token"
    t.string "board_id"
    t.string "list_name_for_backlog"
    t.integer "team_id"
    t.index ["team_id"], name: "index_trello_accounts_on_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "login", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
