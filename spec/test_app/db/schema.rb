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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170117215102) do

  create_table "cars", force: :cascade do |t|
    t.string   "brand"
    t.string   "model"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kpi_manager_dashboards", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kpi_manager_kpis", force: :cascade do |t|
    t.string  "slug"
    t.integer "kpi_type"
    t.string  "unit"
    t.integer "report_id"
  end

  create_table "kpi_manager_reports", force: :cascade do |t|
    t.string   "name"
    t.integer  "send_hour"
    t.integer  "send_frequency"
    t.integer  "send_step"
    t.datetime "send_at"
    t.text     "recipients"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "car_id"
    t.integer  "user_id"
    t.integer  "promotion_id"
    t.float    "paid_price"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "promotions", force: :cascade do |t|
    t.integer "percentage"
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.date     "birthdate"
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
