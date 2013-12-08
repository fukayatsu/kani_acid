class AddIndexToSentences < ActiveRecord::Migration
  def change
    add_index :sentences, :body
  end
end
