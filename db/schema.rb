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

ActiveRecord::Schema[7.0].define(version: 2023_08_18_190101) do
  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.json "rules"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracking_plan_to_event_mappings", force: :cascade do |t|
    t.integer "events_id"
    t.integer "tracking_plans_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["events_id"], name: "index_tracking_plan_to_event_mappings_on_events_id"
    t.index ["tracking_plans_id"], name: "index_tracking_plan_to_event_mappings_on_tracking_plans_id"
  end

  create_table "tracking_plans", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tracking_plan_to_event_mappings", "events", column: "events_id"
  add_foreign_key "tracking_plan_to_event_mappings", "tracking_plans", column: "tracking_plans_id"
end
