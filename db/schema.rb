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

ActiveRecord::Schema.define(version: 2019_04_04_104714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "auction_candidates", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "auction_id"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_auction_candidates_on_auction_id"
    t.index ["user_id"], name: "index_auction_candidates_on_user_id"
  end

  create_table "auctions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "painting_id"
    t.datetime "expire_date", default: "2019-02-22 02:50:25"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id"], name: "index_auctions_on_painting_id"
    t.index ["user_id"], name: "index_auctions_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hex"
  end

  create_table "config_settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer "followed_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.bigint "web_magazine_id"
    t.integer "position"
    t.integer "order"
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["web_magazine_id"], name: "index_interviews_on_web_magazine_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "painting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id"], name: "index_likes_on_painting_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "state"
    t.bigint "order_id"
    t.bigint "option_id"
    t.bigint "painting_id"
    t.integer "quantity"
    t.integer "amount"
    t.integer "shipment_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_line_items_on_option_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["painting_id"], name: "index_line_items_on_painting_id"
  end

  create_table "magazine_comments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "magazine_id"
    t.index ["magazine_id"], name: "index_magazine_comments_on_magazine_id"
    t.index ["user_id"], name: "index_magazine_comments_on_user_id"
  end

  create_table "magazines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "content"
    t.string "thumbnail"
    t.bigint "user_id"
    t.integer "magazine_type", default: 0
    t.integer "priority", default: 0
    t.index ["user_id"], name: "index_magazines_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_type"
    t.string "content"
    t.bigint "painting_id"
    t.integer "original_msg_id"
    t.index ["painting_id"], name: "index_messages_on_painting_id"
  end

  create_table "notices", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.bigint "painting_id"
    t.string "title"
    t.string "price"
    t.string "integer"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id"], name: "index_options_on_painting_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "state"
    t.integer "shipment_state"
    t.string "uid"
    t.string "order_number"
    t.string "shipment_number"
    t.integer "item_total"
    t.integer "shipment_total"
    t.bigint "user_id"
    t.string "name"
    t.string "phone"
    t.string "zipcode"
    t.string "address1"
    t.string "address2"
    t.decimal "payment_amount"
    t.string "payment_info"
    t.string "note"
    t.datetime "completed_at"
    t.integer "payment_method"
    t.datetime "shipped_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "painting_comments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "content"
    t.bigint "painting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id"], name: "index_painting_comments_on_painting_id"
    t.index ["user_id"], name: "index_painting_comments_on_user_id"
  end

  create_table "paintings", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "color_id"
    t.json "images"
    t.string "thumbnail"
    t.string "desc"
    t.bigint "user_id"
    t.datetime "completed_date", default: "2019-01-30 15:42:29"
    t.integer "status", default: 0
    t.bigint "web_magazine_id"
    t.index ["category_id"], name: "index_paintings_on_category_id"
    t.index ["color_id"], name: "index_paintings_on_color_id"
    t.index ["user_id"], name: "index_paintings_on_user_id"
    t.index ["web_magazine_id"], name: "index_paintings_on_web_magazine_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "register_sellers", force: :cascade do |t|
    t.bigint "user_id"
    t.json "images"
    t.boolean "is_confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_register_sellers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "image"
    t.string "desc"
    t.string "instagram"
    t.integer "user_type", default: 0
    t.string "confirmation_token"
    t.string "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "web_magazine_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "web_magazines", force: :cascade do |t|
    t.integer "number"
    t.string "artist_name"
    t.string "image"
    t.string "brief"
    t.string "content1"
    t.string "content2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "web_magazine_group_id"
    t.index ["web_magazine_group_id"], name: "index_web_magazines_on_web_magazine_group_id"
  end

  add_foreign_key "auction_candidates", "auctions"
  add_foreign_key "auction_candidates", "users"
  add_foreign_key "auctions", "paintings"
  add_foreign_key "auctions", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "interviews", "web_magazines"
  add_foreign_key "likes", "paintings"
  add_foreign_key "likes", "users"
  add_foreign_key "line_items", "options"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "paintings"
  add_foreign_key "magazine_comments", "magazines"
  add_foreign_key "magazine_comments", "users"
  add_foreign_key "magazines", "users"
  add_foreign_key "messages", "paintings"
  add_foreign_key "options", "paintings"
  add_foreign_key "orders", "users"
  add_foreign_key "painting_comments", "paintings"
  add_foreign_key "painting_comments", "users"
  add_foreign_key "paintings", "categories"
  add_foreign_key "paintings", "colors"
  add_foreign_key "paintings", "users"
  add_foreign_key "paintings", "web_magazines"
  add_foreign_key "register_sellers", "users"
  add_foreign_key "web_magazines", "web_magazine_groups"
end
