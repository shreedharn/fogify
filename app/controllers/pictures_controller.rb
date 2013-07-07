class PicturesController < FbBaseController
  # GET /pictures
  # GET /pictures.json
  before_filter :authenticate_user!
  include FogifyHelper::GraphHelper  #graph helper defined here

  def index

    @fb_id, access_token =  get_fb_info()
    @graph = get_graph(access_token)
    @from = 0
    @to = DateTime.now().strftime("%s").to_i

    if @graph.nil?
      redirect_to '/auth/facebook'
    else
      begin
        explorer = Explorer.find_by_explorer_id(@fb_id)
        friend_id = (explorer.nil?) ? nil : explorer.friend_id

        from_dt = params['from']
        unless (from_dt.nil?)
          begin
            if (from_dt.length > 0)
              @from = Date.strptime(from_dt,'%m/%d/%Y').strftime("%s").to_i
            end
          rescue => e1
            #ignore block. @from defaults to beginning of epoc
          end
        end

        to_dt = params['to']
        unless (to_dt.nil?)
          begin
            if (to_dt.length > 0)
              @to = Date.strptime(to_dt,'%m/%d/%Y').strftime("%s").to_i
            end
          rescue => e1
            #ignore block. @to is defaults to now
          end
        end


        photo_info = get_photo_with_max_likes(@graph,friend_id,@from,@to)
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