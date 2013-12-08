# rake db:new_migration name=create_chains_sentences
class CreateChainsSentences < ActiveRecord::Migration
  def change
    create_table :chains_sentences, id: false do |t|
      t.references :chain
      t.references :sentence
    end

    add_index :chains_sentences, :chain_id
    add_index :chains_sentences, :sentence_id
  end
end
