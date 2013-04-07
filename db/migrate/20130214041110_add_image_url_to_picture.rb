class AddImageUrlToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :image_url, :string
  end
end
