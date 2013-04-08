class FbAlbumsController < ApplicationController
  # GET /fb_albums
  # GET /fb_albums.json
  include FogifyHelper::GraphHelper
  before_filter :authenticate_user!

  def index

    @max_likes, max_count = nil, nil

    user_auth = current_user.authentications
    this_auth = user_auth.where("uemail = :uemail AND provider = :provider",
                                {:provider => 'facebook', :uemail => current_user.email }).first


    if (this_auth.nil? || this_auth.access_token.nil?)
      redirect_to 'auth/facebook'
    else
      @graph = Koala::Facebook::API.new(this_auth.access_token)
      albums = @graph.get_object("me/albums")
      album_ids = get_album_ids(albums)

      begin
        album_ids.each { |album_id|
          photos = @graph.get_object("#{album_id}/photos") #10151114918023928
          @max_likes, max_count = get_most_liked(photos, @max_likes)
=begin This is for quick testing
          unless @max_likes['comments'].nil?
            break unless @max_likes['comments']['data'].nil?
          end
=end
        }
#          render :text => max.to_s
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @max_likes }
        end
      rescue => e
        p e.message
        raise e
      end


    end

  end

# GET /fb_albums/1
# GET /fb_albums/1.json
  def show
    @fb_album = FbAlbum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fb_album }
    end
  end

# GET /fb_albums/new
# GET /fb_albums/new.json
  def new
    @fb_album = FbAlbum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fb_album }
    end
  end

# GET /fb_albums/1/edit
  def edit
    @fb_album = FbAlbum.find(params[:id])
  end

# POST /fb_albums
# POST /fb_albums.json
  def create
    @fb_album = FbAlbum.new(params[:fb_album])

    respond_to do |format|
      if @fb_album.save
        format.html { redirect_to @fb_album, notice: 'Fb album was successfully created.' }
        format.json { render json: @fb_album, status: :created, location: @fb_album }
      else
        format.html { render action: "new" }
        format.json { render json: @fb_album.errors, status: :unprocessable_entity }
      end
    end
  end

# PUT /fb_albums/1
# PUT /fb_albums/1.json
  def update
    @fb_album = FbAlbum.find(params[:id])

    respond_to do |format|
      if @fb_album.update_attributes(params[:fb_album])
        format.html { redirect_to @fb_album, notice: 'Fb album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fb_album.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /fb_albums/1
# DELETE /fb_albums/1.json
  def destroy
    @fb_album = FbAlbum.find(params[:id])
    @fb_album.destroy

    respond_to do |format|
      format.html { redirect_to fb_albums_url }
      format.json { head :no_content }
    end
  end

end
