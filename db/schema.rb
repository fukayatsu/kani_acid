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

ActiveRecord::Schema.define(:version => 20131208111759) do

  create_table "chains", :force => true do |t|
    t.string   "head"
    t.string   "neck"
    t.string   "word"
    t.integer  "weight",      :default => 100
    t.datetime "censored_at"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "chains", ["censored_at"], :name => "index_chains_on_censored_at"
  add_index "chains", ["head"], :name => "index_chains_on_head"
  add_index "chains", ["neck"], :name => "index_chains_on_neck"
  add_index "chains", ["weight"], :name => "index_chains_on_weight"
  add_index "chains", ["word"], :name => "index_chains_on_word"

  create_table "chains_sentences", :id => false, :force => true do |t|
    t.integer "chain_id"
    t.integer "sentence_id"
  end

  add_index "chains_sentences", ["chain_id"], :name => "index_chains_sentences_on_chain_id"
  add_index "chains_sentences", ["sentence_id"], :name => "index_chains_sentences_on_sentence_id"

  create_table "configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "configs", ["name"], :name => "index_configs_on_name"

  create_table "sentences", :force => true do |t|
    t.string   "body"
    t.integer  "rt_count",   :default => 0
    t.integer  "fav_count",  :default => 0
    t.datetime "tweeted_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "sentences", ["body"], :name => "index_sentences_on_body"
  add_index "sentences", ["fav_count"], :name => "index_sentences_on_fav_count"
  add_index "sentences", ["rt_count"], :name => "index_sentences_on_rt_count"
  add_index "sentences", ["tweeted_at"], :name => "index_sentences_on_tweeted_at"

end
