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

ActiveRecord::Schema[8.1].define(version: 2024_01_26_202921) do
  create_table "eligibility_verifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", precision: nil, null: false
    t.date "expiration_date"
    t.string "name"
    t.integer "passenger_id"
    t.string "phone"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "verifying_agency_id"
    t.index ["passenger_id"], name: "index_eligibility_verifications_on_passenger_id", unique: true
  end

  create_table "issue_tokens", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "singleton"
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["singleton"], name: "index_issue_tokens_on_singleton", unique: true
  end

  create_table "log_entries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "pinned", default: false, null: false
    t.text "text"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
  end

  create_table "mobility_devices", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.boolean "needs_longer_rides", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_mobility_devices_on_name", unique: true
  end

  create_table "passengers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.integer "mobility_device_id"
    t.string "name"
    t.string "net_id"
    t.text "note"
    t.boolean "permanent", default: false, null: false
    t.string "phone"
    t.integer "registered_by"
    t.date "registration_date"
    t.integer "registration_status", default: 0
    t.string "spire"
    t.boolean "subscribed_to_sms", default: false
    t.string "uid"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["net_id"], name: "index_passengers_on_net_id"
    t.index ["spire"], name: "index_passengers_on_spire"
    t.index ["uid"], name: "index_passengers_on_uid"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.boolean "active"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.string "net_id"
    t.string "spire"
    t.string "title"
    t.string "uid"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["net_id"], name: "index_users_on_net_id"
    t.index ["spire"], name: "index_users_on_spire", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  create_table "verifying_agencies", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "needs_contact_info", default: false
    t.index ["name"], name: "index_verifying_agencies_on_name", unique: true
  end
end
