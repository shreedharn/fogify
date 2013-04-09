module FogifyHelper
  module GraphHelper

    #operates on facebook fql.
    #no vanilla object just use the json hash through out
    def get_album_with_max_likes(graph_fql)

      return nil if graph_fql.nil?
      album_max = nil
      #current limit work with 200 albums
      albums =  graph_fql.fql_query("select object_id,  photo_count, like_info.like_count from album where owner=me() LIMIT 0,200")
      return nil if albums.nil?
      album_max = albums[0]
      albums[1..-1].each do |album|
        album_max = album if  album['like_info']['like_count'] > album_max['like_info']['like_count']
      end
      album_max
    end

    def get_pics_info(graph_fql, album_id, limit_count)
      return nil if graph_fql.nil? || album_id.nil? || limit_count.nil?
      # SELECT object_id, caption, src, src_big FROM photo WHERE album_object_id = '10151261394143928' LIMIT 0,12
      # limit count in the query is always the number of images in the album
      query_string = <<-eos
          select object_id, caption, link, src, src_big, src_big_height, src_big_width
          FROM photo WHERE album_object_id = '#{album_id}' LIMIT 0,#{limit_count}
      eos
      photos =  graph_fql.fql_query(query_string)

    end

    def get_photo_with_max_likes(graph_fql)
      return nil if graph_fql.nil?
      this_user = 'me()'
      max_album_count  = '1000' # theoretical limit !

      query_string = <<-eos
        select object_id, album_object_id, like_info from photo  where  (like_info.like_count > 0) AND
        album_object_id IN (select object_id  from album where owner= #{this_user} LIMIT 0, #{max_album_count})
        ORDER BY like_info.like_count DESC LIMIT 0,1
      eos

      photo = graph_fql.fql_query(query_string)
    end

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

