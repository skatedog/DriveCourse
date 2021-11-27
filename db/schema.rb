# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_19_164812) do

  create_table "course_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_likes_on_course_id"
    t.index ["user_id"], name: "index_course_likes_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "vehicle_id"
    t.string "name", null: false
    t.text "introduction"
    t.boolean "is_recorded", default: false, null: false
    t.boolean "avoid_highways", default: false, null: false
    t.boolean "avoid_tolls", default: false, null: false
    t.datetime "departure", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.decimal "latitude", precision: 9, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spot_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "spot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_spot_likes_on_spot_id"
    t.index ["user_id"], name: "index_spot_likes_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "genre_id"
    t.integer "sort_number", null: false
    t.string "name", null: false
    t.text "introduction"
    t.decimal "latitude", precision: 9, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "address", null: false
    t.json "spot_images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "user_image"
    t.text "introduction"
    t.boolean "is_private", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "use_for", default: 0, null: false
    t.integer "category", default: 0, null: false
    t.string "maker", null: false
    t.integer "displacement", null: false
    t.string "name", null: false
    t.text "introduction"
    t.string "vehicle_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
