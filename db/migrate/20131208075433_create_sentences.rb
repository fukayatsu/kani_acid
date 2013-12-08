class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string   :body
      t.integer  :rt_count,  default: 0
      t.integer  :fav_count, default: 0
      t.datetime :tweeted_at

      t.timestamps
    end

    add_index :sentences, :rt_count
    add_index :sentences, :fav_count
    add_index :sentences, :tweeted_at
  end
end
