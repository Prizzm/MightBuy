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

ActiveRecord::Schema.define(:version => 20111107153346) do

  create_table "brands", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "logo"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "social_url"
    t.string   "social_title"
    t.string   "social_desc"
  end

  add_index "brands", ["email"], :name => "index_brands_on_email", :unique => true
  add_index "brands", ["reset_password_token"], :name => "index_brands_on_reset_password_token", :unique => true

  create_table "deal_deals", :force => true do |t|
    t.integer  "brand_id"
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
  end

  create_table "deal_redemptions", :force => true do |t|
    t.integer  "deal_id"
    t.integer  "bank_id"
    t.integer  "cost"
    t.decimal  "value",      :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "inviter_id"
    t.string   "inviter_type"
    t.integer  "invitee_id"
    t.string   "invitee_type"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.string   "code"
    t.string   "type"
    t.datetime "visited_at"
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

  create_table "products", :force => true do |t|
    t.integer  "brand_id"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "rating"
    t.boolean  "liked"
    t.boolean  "tweeted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
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
    t.boolean  "on_invite_list"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
