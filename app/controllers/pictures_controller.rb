class PicturesController < ApplicationController
  # GET /pictures
  # GET /pictures.json
  before_filter :authenticate_user!
  include FogifyHelper::GraphHelper  #graph helper defined here

  def index
    user_auth = current_user.authentications
    this_auth = user_auth.where("uemail = :uemail AND provider = :provider",
                                {:provider => 'facebook', :uemail => current_user.email}).first

    if (this_auth.nil? || this_auth.access_token.nil?)
      redirect_to '/auth/facebook'
    else
      @graph = Koala::Facebook::API.new(this_auth.access_token)
      @profile  = @graph.get_object("me")
      begin
        explorer = Explorer.find_by_explorer_id(@profile['id'])
        friend_id = (explorer.nil?) ? nil : explorer.friend_id
        photo_info = get_photo_with_max_likes(@graph,friend_id)
        unless photo_info.nil?
          photo_id = photo_info[0]['object_id']
          #go graph route to avoid multiple FQL for maintainability
          @max_likes = @graph.get_object("#{photo_id}")
        end
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @max_likes }
        end
      rescue => e
        # p e.to_s
        @error_flag = true
      end
    end

  end


  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

end