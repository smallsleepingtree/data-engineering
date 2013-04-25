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

ActiveRecord::Schema.define(:version => 20130425162512) do

  create_table "customers", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "customers", ["name"], :name => "index_customers_on_name", :unique => true

  create_table "deals", :force => true do |t|
    t.string   "description", :null => false
    t.integer  "price_cents", :null => false
    t.integer  "merchant_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "deals", ["merchant_id", "description", "price_cents"], :name => "index_deals_on_merchant_description_price", :unique => true

  create_table "merchants", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "merchants", ["name", "address"], :name => "index_merchants_on_name_and_address", :unique => true

  create_table "order_logs", :force => true do |t|
    t.integer  "gross_revenue_cents"
    t.text     "source_data"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "filename"
    t.integer  "uploader_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "quantity",     :null => false
    t.integer  "customer_id",  :null => false
    t.integer  "deal_id",      :null => false
    t.integer  "order_log_id", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "orders", ["order_log_id"], :name => "index_orders_on_order_log_id"

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "password_digest",                    :null => false
    t.boolean  "authorized",      :default => false, :null => false
    t.boolean  "admin",           :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "rejected_at"
    t.string   "openid_url"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
