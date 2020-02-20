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

ActiveRecord::Schema.define(version: 2019_09_03_182443) do

  create_table "guests", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "expertise"
    t.integer "interview_id"
  end

  create_table "hosts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
  end

  create_table "interviews", force: :cascade do |t|
    t.string "date"
    t.boolean "recorded", default: false
    t.boolean "published", default: false
    t.integer "show_id"
    t.integer "guest_id"
    t.string "start_time"
    t.string "end_time"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "category"
    t.string "url"
    t.string "duration"
    t.integer "host_id"
  end

end
