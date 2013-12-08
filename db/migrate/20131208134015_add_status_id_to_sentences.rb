class AddStatusIdToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :status_id, :string
    add_index :sentences,  :status_id
  end
end
