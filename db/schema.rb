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

ActiveRecord::Schema.define(version: 2024_01_18_184517) do

  create_table "eligibility_verifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "passenger_id"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "verifying_agency_id"
    t.string "name"
    t.text "address"
    t.string "phone"
    t.index ["passenger_id"], name: "index_eligibility_verifications_on_passenger_id", unique: true
  end

  create_table "issue_tokens", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "token"
    t.integer "singleton"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["singleton"], name: "index_issue_tokens_on_singleton", unique: true
  end

  create_table "log_entries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pinned", default: false, null: false
  end

  create_table "mobility_devices", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "needs_longer_rides", default: false, null: false
    t.index ["name"], name: "index_mobility_devices_on_name", unique: true
  end

  create_table "passengers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "address"
    t.string "phone"
    t.boolean "permanent", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.integer "mobility_device_id"
    t.string "spire"
    t.integer "registered_by"
    t.integer "registration_status", default: 0
    t.date "registration_date"
    t.boolean "subscribed_to_sms", default: false
    t.string "uid"
    t.string "net_id"
    t.index ["net_id"], name: "index_passengers_on_net_id"
    t.index ["spire"], name: "index_passengers_on_spire"
    t.index ["uid"], name: "index_passengers_on_uid"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "spire"
    t.boolean "active"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "net_id"
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
