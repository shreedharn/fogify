class Picture < ActiveRecord::Base
  attr_accessible :album_id, :img_comment, :img_name, :image, :image_url
  belongs_to :album
end
