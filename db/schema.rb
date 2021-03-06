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

ActiveRecord::Schema.define(:version => 20130414134430) do

  create_table "destinations", :force => true do |t|
    t.integer  "entry_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "entries", :force => true do |t|
    t.text     "message",                   :null => false
    t.integer  "user_id",                   :null => false
    t.integer  "family_id",                 :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.datetime "posted_on",                 :null => false
    t.integer  "face",       :default => 0, :null => false
  end

  create_table "families", :force => true do |t|
    t.string   "login_name",   :limit => 64, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "display_name"
  end

  add_index "families", ["login_name"], :name => "index_families_on_name", :unique => true

  create_table "neighborhoods", :force => true do |t|
    t.integer  "family_id"
    t.integer  "neighbor_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "rejected",    :default => false, :null => false
    t.boolean  "accepted",    :default => false, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login_name",          :limit => 64,                      :null => false
    t.string   "display_name",        :limit => 250,                     :null => false
    t.string   "password_digest",                                        :null => false
    t.string   "mail_address",        :limit => 250,                     :null => false
    t.boolean  "aruji",                              :default => false,  :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "family_id",                                              :null => false
    t.datetime "verified_at"
    t.string   "auto_login_token"
    t.string   "verification_token"
    t.string   "face",                               :default => "gray", :null => false
    t.boolean  "notice",                             :default => true,   :null => false
    t.boolean  "notice_only_replied",                :default => false,  :null => false
  end

  add_index "users", ["login_name"], :name => "index_users_on_login_name"

end
