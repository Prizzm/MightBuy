# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120112215551) do

  create_table "deal_deals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "for_id"
    t.string   "for_type"
    t.string   "title"
    t.text     "description"
    t.integer  "low_cost"
    t.integer  "high_cost"
    t.decimal  "low_value",   :precision => 8, :scale => 2
    t.decimal  "high_value",  :precision => 8, :scale => 2
    t.string   "value_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
  end

  create_table "deal_redemptions", :force => true do |t|
    t.integer  "deal_id"
    t.integer  "bank_id"
    t.integer  "cost"
    t.decimal  "value",      :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "point_allocations", :force => true do |t|
    t.integer  "bank_id"
    t.integer  "allocatable_id"
    t.string   "allocatable_type"
    t.string   "allocator"
    t.integer  "points",                         :default => 0
    t.string   "lookup",           :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "point_allocations", ["lookup"], :name => "index_point_allocations_on_lookup", :unique => true

  create_table "point_banks", :force => true do |t|
    t.integer  "bankable_id"
    t.string   "bankable_type"
    t.integer  "total",         :default => 0
    t.integer  "available",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "visitor_code"
    t.string   "image"
    t.boolean  "recommended"
    t.integer  "share_id"
    t.integer  "reply_id"
  end

  create_table "shares", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.string   "with"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "visitor_code"
    t.string   "shortcode"
  end

  add_index "shares", ["shortcode"], :name => "index_shares_on_shortcode", :unique => true

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "shortcode"
    t.string   "image"
    t.string   "subject"
    t.text     "body"
    t.string   "access"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recommendable", :default => false
    t.string   "form"
    t.string   "url"
  end

  add_index "topics", ["shortcode"], :name => "index_topics_on_shortcode", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",       :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "description"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "phone"
    t.string   "email_address"
    t.string   "category",                              :default => "person"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
