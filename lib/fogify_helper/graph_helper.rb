module FogifyHelper
  module GraphHelper
    def get_album_ids (album_collections)
      album_ids = []
      return nil if album_collections.nil?
      album_collections.each { |outer_hash|
        album_ids.push(outer_hash["id"])
      }
      album_ids
    end

    def get_likes_info(graph_hash)
      likes_hash = graph_hash['likes']
      p likes_hash
    end

    def get_likes_count (graph_hash)
      likes_hash = graph_hash['likes']
      return 0 if likes_hash.nil?
      likes_hash['data'].size
    end

    def get_most_liked(photo_collections, curr_max)
      most_liked = nil # returns the photo object with max likes

      return nil, nil if photo_collections.nil?

      most_liked = curr_max
      most_liked = photo_collections[0] if most_liked.nil?
      most_liked_count = get_likes_count(most_liked)

      like_count = 0

      photo_collections.each { |outer_hash|
        like_count = get_likes_count (outer_hash)
        if (like_count > most_liked_count)
          most_liked = outer_hash
        end
      }
      return most_liked, most_liked_count
    end
  end
end

