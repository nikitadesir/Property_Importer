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

ActiveRecord::Schema[8.1].define(version: 2026_02_12_050118) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string "building_name", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.string "state", null: false
    t.string "street_address", null: false
    t.datetime "updated_at", null: false
    t.string "zip_code", null: false
    t.index "lower((building_name)::text), lower((street_address)::text), lower((city)::text), lower((state)::text), lower((zip_code)::text)", name: "index_properties_on_normalized_address", unique: true
  end

  create_table "units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "property_id", null: false
    t.string "unit_number", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "unit_number"], name: "index_units_on_property_and_normalized_unit_number", unique: true
    t.index ["property_id"], name: "index_units_on_property_id"
  end

  add_foreign_key "units", "properties"
end
