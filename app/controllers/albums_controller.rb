class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  include FbAlbumsHelper #erb helper defined here
  include FogifyHelper::GraphHelper  #graph helper defined here

  before_filter :authenticate_user!

  def index
    user_auth = current_user.authentications
    this_auth = user_auth.where("uemail = :uemail AND provider = :provider",
                    {:provider => 'facebook', :uemail => current_user.email }).first

    if (this_auth.nil? || this_auth.access_token.nil?)
      redirect_to '/auth/facebook'
    else
      @graph = Koala::Facebook::API.new(this_auth.access_token)
      #@albums = @graph.get_object("me/albums")
      begin
      @photos =   get_photos_in_max_likes_album(@graph)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @photos }
      end
      rescue => e
        # p e.to_s
        @error_flag = true
      end
    end

  end

end
