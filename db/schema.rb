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

ActiveRecord::Schema.define(version: 20161205140721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.string   "phrase"
    t.float    "sentiment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "url"
    t.string   "name"
    t.string   "brand"
    t.float    "overall_rating"
    t.integer  "num_reviews"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "review_matches", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_review_matches_on_match_id", using: :btree
    t.index ["review_id"], name: "index_review_matches_on_review_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "product_id"
    t.date     "date_submitted"
    t.float    "score"
    t.string   "username"
    t.boolean  "verified_purchase", default: false
    t.string   "title"
    t.text     "text"
    t.integer  "num_comments"
    t.integer  "num_helpful_votes"
    t.string   "comments_url"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["product_id"], name: "index_reviews_on_product_id", using: :btree
  end

end
