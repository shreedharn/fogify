class AlbumsController < FbBaseController
  # GET /albums
  # GET /albums.json
  include FbAlbumsHelper #erb helper defined here
  include FogifyHelper::GraphHelper  #graph helper defined here

  before_filter :authenticate_user!

  def index
    @fb_id, access_token =  get_fb_info()
    @graph = get_graph(access_token)
    if @graph.nil?
      redirect_to '/auth/facebook'
    else
      @profile  = @graph.get_object("me")
      begin
        explorer = Explorer.find_by_explorer_id(@profile['id'])
        friend_id = (explorer.nil?) ? nil : explorer.friend_id
        @photos =   get_photos_in_max_likes_album(@graph,friend_id)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @photos }
      end
      rescue => e
        @error_flag = true
      end
    end

  end

end
