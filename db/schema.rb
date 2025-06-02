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

ActiveRecord::Schema[7.0].define(version: 2025_06_02_021548) do
  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "street_details"
    t.string "number"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "acronym"
  end

  create_table "gas_station_products", force: :cascade do |t|
    t.integer "gas_station_id", null: false
    t.integer "product_id", null: false
    t.float "price_per_liter", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gas_station_id"], name: "index_gas_station_products_on_gas_station_id"
    t.index ["product_id"], name: "index_gas_station_products_on_product_id"
  end

  create_table "gas_stations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_gas_stations_on_address_id", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount", default: 0, null: false
  end

  create_table "refuelings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "gas_station_id", null: false
    t.decimal "liters", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.decimal "discount_applied", precision: 5, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id", null: false
    t.index ["gas_station_id"], name: "index_refuelings_on_gas_station_id"
    t.index ["product_id"], name: "index_refuelings_on_product_id"
    t.index ["user_id"], name: "index_refuelings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "users_email_index", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.float "balance"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "gas_station_products", "gas_stations"
  add_foreign_key "gas_station_products", "products"
  add_foreign_key "gas_stations", "addresses"
  add_foreign_key "refuelings", "gas_stations"
  add_foreign_key "refuelings", "products"
  add_foreign_key "refuelings", "users"
  add_foreign_key "wallets", "users"
end
