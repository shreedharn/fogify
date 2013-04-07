class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :album_id
      t.string :img_name
      t.string :img_comment

      t.timestamps
    end
  end
end
