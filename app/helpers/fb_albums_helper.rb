module FbAlbumsHelper

  #erb helper
  def getimg_w_h (photos)
    photo_wide,photo_tall = [], []
    return nil if photos.nil?
    photos.each do |photo|
      if (photo['src_big_width'] > photo['src_big_height'])
         photo_wide << photo
      else
         photo_tall << photo
      end
    end
    return photo_wide,photo_tall
  end

end
