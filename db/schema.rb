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

ActiveRecord::Schema.define(version: 20180805182411) do

  create_table "matches", force: :cascade do |t|
    t.string "opponent"
    t.string "tickets_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eventim_id"
  end

  create_table "telegram_subscriptions", force: :cascade do |t|
    t.integer "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "eventim_id"
    t.string "prices"
    t.string "seat_description"
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_tickets_on_match_id"
  end

end
