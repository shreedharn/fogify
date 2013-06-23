module FogifyHelper
  module GraphHelper

    def get_graph(access_token)
      return nil if access_token.nil?
      graph = Koala::Facebook::API.new(access_token)
    end

    def get_friends_of_me(graph_fql,graph_user)
      return nil if graph_fql.nil?
      if (graph_user.nil?)
        this_user = 'me()'
      else
        this_user = graph_user
      end
      query_string = <<-eos
        select uid, name from user where uid IN (select uid2 from friend where uid1=#{this_user})
      eos
      friends = graph_fql.fql_query(query_string)
    end

    #operates on facebook fql.
    #no vanilla object just use the json as it is
    def get_photos_in_max_likes_album(graph_fql, graph_user)
      return nil if graph_fql.nil?
      if graph_user.nil?
        this_user = 'me()'
      else
        this_user = graph_user
      end
      query_string = <<-eos
          select object_id, caption, link, src, src_big, src_big_height, src_big_width
          FROM photo WHERE album_object_id IN
            (select object_id,  photo_count, like_info.like_count from album where owner=#{this_user}
            ORDER BY like_info.like_count DESC LIMIT 0,1)
       eos
      photos =  graph_fql.fql_query(query_string)

    end

    def get_photo_with_max_likes(graph_fql,graph_user,time_from,time_to)
      return nil if graph_fql.nil?
      if graph_user.nil?
        this_user = 'me()'
      else
        this_user = graph_user
      end
      query_string = <<-eos
        select object_id, album_object_id, like_info from photo  where  owner= #{this_user}
        AND created > #{time_from} AND created < #{time_to}
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

