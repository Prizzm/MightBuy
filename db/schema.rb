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

ActiveRecord::Schema.define(:version => 20120802204451) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "auth_providers", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bargins", :force => true do |t|
    t.string   "name"
    t.string   "offer"
    t.string   "type"
    t.text     "description"
    t.string   "url"
    t.integer  "product_id",  :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beta_signups", :force => true do |t|
    t.string   "email_address"
    t.string   "visitor_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "responses", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "visitor_code"
    t.boolean  "recommended"
    t.integer  "share_id"
    t.integer  "reply_id"
    t.string   "recommend_type"
    t.string   "image_uid"
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
    t.boolean  "registered",   :default => false
  end

  add_index "shares", ["shortcode"], :name => "index_shares_on_shortcode", :unique => true

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "shortcode"
    t.string   "subject"
    t.text     "body"
    t.string   "access"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recommendable",    :default => false
    t.string   "form"
    t.string   "url"
    t.string   "share_title"
    t.string   "image_uid"
    t.float    "price"
    t.integer  "offer"
    t.string   "mobile_image_url"
    t.integer  "product_id"
  end

  add_index "topics", ["shortcode"], :name => "index_topics_on_shortcode", :unique => true

  create_table "uploads", :force => true do |t|
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "description"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "phone"
    t.string   "email_address"
    t.string   "category",                              :default => "person"
    t.string   "image_uid"
    t.string   "authentication_token"
    t.string   "facebook_uid"
    t.string   "twitter_uid"
    t.string   "facebook_oauth_token"
    t.string   "facebook_oauth_secret"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_secret"
    t.datetime "last_seen"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
