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

ActiveRecord::Schema[7.0].define(version: 2024_02_04_161752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disbursement_orders", force: :cascade do |t|
    t.bigint "disbursement_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disbursement_id"], name: "index_disbursement_orders_on_disbursement_id"
    t.index ["order_id"], name: "disbursement_orders_order_id_unique", unique: true
    t.index ["order_id"], name: "index_disbursement_orders_on_order_id"
  end

  create_table "disbursements", force: :cascade do |t|
    t.string "reference", limit: 32, null: false
    t.bigint "merchant_id", null: false
    t.integer "gross_amount_cents", default: 0, null: false
    t.string "gross_amount_currency", default: "EUR", null: false
    t.integer "net_amount_cents", default: 0, null: false
    t.string "net_amount_currency", default: "EUR", null: false
    t.integer "fee_amount_cents", default: 0, null: false
    t.string "fee_amount_currency", default: "EUR", null: false
    t.integer "fee_minimum_amount_cents", default: 0, null: false
    t.string "fee_minimum_amount_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fee_minimum_amount_cents"], name: "index_disbursements_on_fee_minimum_amount_cents"
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
    t.index ["reference"], name: "index_disbursements_on_reference"
  end

  create_table "merchants", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "reference", null: false
    t.string "disbursement_frequency"
    t.integer "minimum_monthly_fee_cents", default: 0, null: false
    t.string "minimum_monthly_fee_currency", default: "EUR", null: false
    t.date "live_on"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "merchant_reference", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.boolean "disbursed", default: false, null: false
    t.date "disbursed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["disbursed"], name: "index_orders_on_disbursed"
    t.index ["disbursed_at"], name: "index_orders_on_disbursed_at"
  end

  add_foreign_key "disbursement_orders", "disbursements"
  add_foreign_key "disbursement_orders", "orders"
  add_foreign_key "disbursements", "merchants"
  add_foreign_key "orders", "merchants", column: "merchant_reference", primary_key: "reference"
end
