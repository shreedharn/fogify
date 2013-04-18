class PicturesController < FbBaseController
  # GET /pictures
  # GET /pictures.json
  before_filter :authenticate_user!
  include FogifyHelper::GraphHelper  #graph helper defined here

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