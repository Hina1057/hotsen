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

ActiveRecord::Schema[7.0].define(version: 2026_01_08_024714) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "address", null: false
    t.date "birthday", null: false
    t.integer "sex", default: 0, null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "area", null: false
    t.string "phone_number", null: false
    t.boolean "wifi", default: false, null: false
    t.boolean "large_bath", default: false, null: false
    t.boolean "openair_bath", default: false, null: false
    t.boolean "sauna", default: false, null: false
    t.boolean "bedrock_bath", default: false, null: false
    t.boolean "barrier_free", default: false, null: false
    t.boolean "smoking_area", default: false, null: false
    t.text "information"
    t.string "hotel_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parking_capacity"
  end

  create_table "informations", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "hotel_id", null: false
    t.integer "room_id", null: false
    t.date "check_in_on", null: false
    t.integer "stay_count", default: 1, null: false
    t.integer "guest_count", default: 1, null: false
    t.integer "pay_method", default: 0, null: false
    t.boolean "breakfast", default: false, null: false
    t.boolean "dinner", default: false, null: false
    t.integer "total_price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reservations_on_account_id"
    t.index ["hotel_id"], name: "index_reservations_on_hotel_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "hotel_id", null: false
    t.integer "room_type", default: 0, null: false
    t.integer "max_person", default: 1, null: false
    t.integer "room_price", null: false
    t.integer "room_stock", default: 0, null: false
    t.string "room_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id", "room_type"], name: "index_rooms_on_hotel_id_and_room_type", unique: true
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
  end

  add_foreign_key "reservations", "accounts"
  add_foreign_key "reservations", "hotels"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "rooms", "hotels"
end
