class CreateExplorers < ActiveRecord::Migration
  def change
    create_table :explorers do |t|
      t.string :explorer_id
      t.string :friend_id

      t.timestamps
    end
  end
end
