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

ActiveRecord::Schema.define(:version => 20130106102743) do

  create_table "smokes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "wolf_id"
    t.integer  "parent_user_id"
    t.string   "url_token"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "smokes", ["parent_user_id"], :name => "index_smokes_on_parent_user_id"
  add_index "smokes", ["url_token"], :name => "index_smokes_on_url_token", :unique => true
  add_index "smokes", ["user_id", "wolf_id"], :name => "index_smokes_on_user_id_and_wolf_id", :unique => true
  add_index "smokes", ["user_id"], :name => "index_smokes_on_user_id"
  add_index "smokes", ["wolf_id"], :name => "index_smokes_on_wolf_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "wolves", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wolves", ["user_id", "created_at"], :name => "index_wolves_on_user_id_and_created_at"

end
