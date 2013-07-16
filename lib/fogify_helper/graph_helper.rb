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

    def get_basic_users_info(graph_fql, users)
      return if nil if graph_fql.nil?
      query_strings = {}

      for i in 0..(users.length - 1)
        query_strings[users[i]] = <<-eos
          select name, pic_square from user where uid = #{users[i]} LIMIT 1000
          eos
      end
      graph_fql.fql_multiquery(query_strings)

    end

    def get_top_friends_likes(graph_fql, graph_user)
      return if nil if graph_fql.nil?
      if graph_user.nil?
        this_user = 'me()'
      else
        this_user = graph_user
      end
      query_string = <<-eos
        SELECT user_id FROM like WHERE user_id != #{this_user} AND object_id IN
        (select object_id from photo where owner = #{this_user} AND like_info.like_count > 0 LIMIT 2000)
      eos
=begin
      query_string = <<-eos
        SELECT user_id FROM like WHERE user_id != #{this_user} AND object_id IN
        (select status_id from status where uid = #{this_user} AND like_info.like_count > 0 LIMIT 2000)
      eos
=end
      result = graph_fql.fql_query(query_string)

    end
  end
end

