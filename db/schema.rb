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

ActiveRecord::Schema.define(:version => 20121109063845) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "anti_forge_tokens", :force => true do |t|
    t.string   "value"
    t.date     "date_created"
    t.boolean  "active"
    t.integer  "product_id"
    t.integer  "bargin_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "pass_path"
    t.integer  "user_id"
    t.string   "serial_number"
    t.string   "device_id"
    t.string   "authorization_token"
  end

  create_table "auth_providers", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bargins", :force => true do |t|
    t.string   "name"
    t.string   "offer"
    t.string   "type"
    t.text     "description"
    t.string   "url"
    t.integer  "product_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "value"
    t.string   "application"
    t.string   "bargin_type"
    t.string   "barcode"
    t.boolean  "accept_payments"
    t.decimal  "discount",        :precision => 6, :scale => 2
    t.string   "payment_type",                                  :default => "MightBuy"
  end

  create_table "beta_signups", :force => true do |t|
    t.string   "email_address"
    t.string   "visitor_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "business_products", :force => true do |t|
    t.integer  "business_id"
    t.integer  "product_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "business_staffs", :force => true do |t|
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
    t.string   "authentication_token"
    t.integer  "business_id"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "name"
  end

  add_index "business_staffs", ["email"], :name => "index_business_staffs_on_email", :unique => true
  add_index "business_staffs", ["reset_password_token"], :name => "index_business_staffs_on_reset_password_token", :unique => true

  create_table "business_urls", :force => true do |t|
    t.string   "domain"
    t.integer  "business_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "foreground"
    t.string   "background"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "description"
    t.string   "logo_uid"
    t.string   "email"
    t.string   "phone"
    t.string   "facebook_url"
    t.string   "twitter_handle"
    t.string   "pinterest_handle"
    t.text     "address"
    t.boolean  "url_verified"
    t.boolean  "profile_updated"
  end

  create_table "cards", :force => true do |t|
    t.string   "address_city"
    t.string   "address_country"
    t.string   "address_line1"
    t.string   "address_line1_check"
    t.string   "address_line2"
    t.string   "address_line2_check"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "address_zip_check"
    t.string   "country"
    t.string   "cvc_check"
    t.string   "exp_month"
    t.integer  "exp_year"
    t.string   "fingerprint"
    t.string   "last4"
    t.string   "name"
    t.string   "card_object"
    t.string   "card_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "order_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "topic_id",                    :null => false
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "description", :default => ""
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "customer_leads", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "status",                                     :default => "notsent"
    t.integer  "product_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "business_id",                                                       :null => false
    t.string   "phone_number"
    t.boolean  "join_list",                                  :default => false
    t.string   "photo_uid"
    t.decimal  "price",        :precision => 6, :scale => 2
    t.string   "invite_token"
    t.integer  "user_id"
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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "photo"
  end

  create_table "deal_redemptions", :force => true do |t|
    t.integer  "deal_id"
    t.integer  "bank_id"
    t.integer  "cost"
    t.decimal  "value",      :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
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
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "fees", :force => true do |t|
    t.string   "fee_type"
    t.string   "application"
    t.string   "currency"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lead_configs", :force => true do |t|
    t.integer  "business_id"
    t.boolean  "include_liability",      :default => false
    t.text     "liability",              :default => ""
    t.boolean  "ask_for_name",           :default => false
    t.boolean  "ask_to_join_list",       :default => false
    t.boolean  "include_product_select", :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "ask_for_phonenumber",    :default => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "topic_id"
    t.string   "invoice_id"
    t.float    "amount"
    t.float    "amount_refunded"
    t.integer  "created_stripe"
    t.string   "currency"
    t.string   "customer"
    t.string   "description"
    t.boolean  "disputed"
    t.string   "failure_message"
    t.float    "fee"
    t.string   "invoice"
    t.boolean  "livemode"
    t.string   "object"
    t.string   "paid"
    t.boolean  "refunded"
    t.integer  "card_id"
    t.integer  "fee_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "fulfilled"
  end

  create_table "point_allocations", :force => true do |t|
    t.integer  "bank_id"
    t.integer  "allocatable_id"
    t.string   "allocatable_type"
    t.string   "allocator"
    t.integer  "points",                         :default => 0
    t.string   "lookup",           :limit => 40
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "point_allocations", ["lookup"], :name => "index_point_allocations_on_lookup", :unique => true

  create_table "point_banks", :force => true do |t|
    t.integer  "bankable_id"
    t.string   "bankable_type"
    t.integer  "total",         :default => 0
    t.integer  "available",     :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.integer  "business_id"
    t.boolean  "accept_payments"
    t.float    "price"
    t.string   "domain_name"
  end

  create_table "responses", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "visitor_code"
    t.string   "shortcode"
    t.boolean  "registered",   :default => false
  end

  add_index "shares", ["shortcode"], :name => "index_shares_on_shortcode", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timeline_events", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "timeline_events", ["actor_id", "actor_type"], :name => "index_timeline_events_on_actor_id_and_actor_type"
  add_index "timeline_events", ["secondary_subject_id", "secondary_subject_type"], :name => "secondary_subject_timeline_events"
  add_index "timeline_events", ["subject_id", "subject_type"], :name => "index_timeline_events_on_subject_id_and_subject_type"

  create_table "topic_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "topic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "shortcode"
    t.string   "subject"
    t.text     "body"
    t.string   "access"
    t.string   "type"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "recommendable",    :default => false
    t.string   "form"
    t.string   "url"
    t.string   "share_title"
    t.string   "image_uid"
    t.float    "price"
    t.integer  "offer"
    t.string   "mobile_image_url"
    t.integer  "product_id"
    t.string   "status",           :default => "imightbuy"
    t.string   "recommendation",   :default => "undecided"
  end

  add_index "topics", ["shortcode"], :name => "index_topics_on_shortcode", :unique => true

  create_table "uploads", :force => true do |t|
    t.string   "image_uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
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
    t.string   "slug"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "topic_id",                      :null => false
    t.integer  "user_id"
    t.boolean  "buyit",      :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
