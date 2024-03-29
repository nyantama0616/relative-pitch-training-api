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

ActiveRecord::Schema[7.0].define(version: 2024_02_19_102504) do
  create_table "questionnaires", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "data", null: false
    t.index ["user_id"], name: "index_questionnaires_on_user_id"
  end

  create_table "train_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_train_records_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "user_name", default: "panda"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_path", default: "panda.jpg"
    t.boolean "shimamura?", default: false, null: false
    t.string "subname"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "questionnaires", "users"
  add_foreign_key "train_records", "users"
end
