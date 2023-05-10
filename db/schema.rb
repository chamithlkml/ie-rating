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

ActiveRecord::Schema[7.0].define(version: 2023_05_10_163123) do
  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ie_statements", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "user_id"
    t.datetime "discarded_at"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ie_statements_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "path"
    t.string "imageable_type", null: false
    t.integer "imageable_id", null: false
    t.integer "employees_id"
    t.integer "products_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employees_id"], name: "index_pictures_on_employees_id"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable"
    t.index ["products_id"], name: "index_pictures_on_products_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statement_entries", force: :cascade do |t|
    t.string "description", default: "", null: false
    t.integer "amount", default: 0
    t.integer "ie_statement_id"
    t.integer "entry_type", default: 0, null: false
    t.datetime "discarded_at"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_type"], name: "index_statement_entries_on_entry_type"
    t.index ["ie_statement_id"], name: "index_statement_entries_on_ie_statement_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ie_statements", "users"
  add_foreign_key "pictures", "employees", column: "employees_id"
  add_foreign_key "pictures", "products", column: "products_id"
  add_foreign_key "statement_entries", "ie_statements"
end
