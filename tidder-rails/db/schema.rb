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

ActiveRecord::Schema.define(version: 20160105154236) do

  create_table "comments", force: :cascade do |t|
    t.text    "text"
    t.integer "parent_id"
    t.integer "user_id"
    t.integer "post_id"
  end

  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id"
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "friendships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "friend_id"
    t.integer "trust_level"
  end

  add_index "friendships", ["follower_id"], name: "index_friendships_on_follower_id"
  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"

  create_table "posts", force: :cascade do |t|
    t.text    "title"
    t.text    "body"
    t.integer "user_id"
    t.integer "topic_id"
    t.integer "predecessor_id"
  end

  add_index "posts", ["predecessor_id"], name: "index_posts_on_predecessor_id"
  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "topics", force: :cascade do |t|
    t.text    "name"
    t.text    "about"
    t.integer "user_id"
    t.integer "parent_id"
  end

  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id"
  add_index "topics", ["user_id"], name: "index_topics_on_user_id"

  create_table "users", force: :cascade do |t|
    t.text "name"
    t.text "username"
    t.text "description"
    t.text "email"
    t.text "password_digest"
  end

end
