# rake db:new_migration name=create_chains
class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.string   :head
      t.string   :neck
      t.string   :word
      t.integer  :weight, default: 100
      t.datetime :censored_at

      t.timestamps
    end

    add_index :chains, :head
    add_index :chains, :neck
    add_index :chains, :word
    add_index :chains, :weight
    add_index :chains, :censored_at
  end
end
